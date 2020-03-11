class IntercomController < ApplicationController # rubocop:disable Metrics/ClassLength
  skip_before_action :verify_authenticity_token
  skip_before_action :validate_company_expiry

  GCM_IV_LENGTH = 12
  GCM_AUTH_TAG_LENGTH = 16

  def sheets
    intercom_data = validate_request_and_decrtypt_data
    company = CompanySetting.find_by_intercom_workspace_id!(intercom_data.app_id).company
    board = company.boards.friendly.find(company.company_setting.intercom_default_board_slug)
    user = User.find_by_email(intercom_data.email)

    sign_in(user)

    redirect_to board_url(board, host: "#{company.subdomain}.getcadet.com", intercom_iframe: true)
  end

  def new
    render json: {
      canvas: {
        content: {
          components: [{
            "type": "text",
            "text": "*Share ideas or feedback*",
            "style": "header"
          }, {
            "type": "button",
            "id": "submit-issue-form",
            "label": "Submit Feature Request",
            "style": "primary",
            "action": {
              "type": "sheet",
              "url": "https://6cb33666.ngrok.io/intercom/sheets"
            }
          }]
        }
      }
    }
  end

  def configure
    if params.key?(:input_values)
      save_and_render_configuration
    else
      render_canvas(configuration_components)
    end
  end

  private

  def save_and_render_configuration # rubocop:disable Metrics/MethodLength
    input_values = params[:input_values]
    company = Company.find_by_subdomain!(input_values[:subdomain])
    board = company.boards.friendly.find(input_values[:board_slug])

    if ActiveSupport::SecurityUtils.secure_compare(company.company_setting.api_key, input_values["api_key"])
      company.company_setting.intercom_workspace_id = params[:workspace_id]
      company.company_setting.intercom_default_board_slug = board.slug
      company.company_setting.save!

      render json: {
        results: {
          success: true
        }
      }
    else
      render_canvas(configuration_components(
        subdomain: input_values[:subdomain],
        board_slug: input_values[:board_slug]
      ) << {
        "type": "text",
        "text": "*API Key Incorrect*",
        "style": "error"
      })
    end
  rescue ActiveRecord::RecordNotFound => error
    error_message = error.message
    # if model is nil, its because boards.friendly.find failed to find a record
    error_message = "Couldn't find Board" if error.model.nil?

    render_canvas(configuration_components(
      subdomain: input_values[:subdomain],
      board_slug: input_values[:board_slug]
    ) << {
      "type": "text",
      "text": "*#{error_message}*",
      "style": "error"
    })
  end

  def render_canvas(components)
    render json: {
      canvas: {
        content: {
          components: components
        }
      }
    }
  end

  def configuration_components(subdomain: nil, board_slug: nil)
    [{
      "type": "input",
      "id": "subdomain",
      "label": "Enter the subdomain of your Cadet account",
      "placeholder": "Cadet Subdomain",
      "value": subdomain
    }, {
      "type": "input",
      "id": "board_slug",
      "label": "Enter the Board ID to show your users",
      "placeholder": "Board ID",
      "value": board_slug
    }, {
      "type": "input",
      "id": "api_key",
      "label": "API Key",
      "placeholder": "Find your API key in Cadet > Settings"
    }, {
      "type": "button",
      "id": "submit-api-token",
      "label": "Submit",
      "style": "primary",
      "action": {
        "type": "submit"
      }
    }]
  end

  def validate_request_and_decrtypt_data
    intercom_data = JSON.parse(params[:intercom_data])
    decoded_user = Base64.decode64(intercom_data["user"].encode('utf-8'))

    secret = Rails.application.secrets.intercom[:app_store_secret]
    key = Digest::SHA256.digest(secret)
    decipher = ::OpenSSL::Cipher.new('aes-256-gcm')

    decipher.decrypt
    decipher.key = key
    decipher.iv = decoded_user[0, GCM_IV_LENGTH]
    decipher.auth_tag = decoded_user[(decoded_user.length - GCM_AUTH_TAG_LENGTH), GCM_AUTH_TAG_LENGTH]
    ciphertext = decoded_user[GCM_IV_LENGTH, (decoded_user.length - GCM_AUTH_TAG_LENGTH - GCM_IV_LENGTH)]

    Hashie::Mash.new(JSON.parse(decipher.update(ciphertext) + decipher.final))
  end
end
