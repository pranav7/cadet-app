class IntercomController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :validate_company_expiry

  GCM_IV_LENGTH = 12
  GCM_AUTH_TAG_LENGTH = 16

  def new
    render json: {
      canvas: {
        content: {
          components: [
            {
              "type": "text",
              "text": "*Have ideas or feedback?*",
              "style": "header"
            },

            {
              "type": "button",
              "id": "submit-issue-form",
              "label": "Submit Feature Request",
              "style": "primary",
              "action": {
                "type": "sheet",
                "url": "https://app.getcadet.com/intercom/sheets"
              }
            }
          ]
        }
      }
    }
  end

  def sheets
    intercom_data = validate_request_and_decrtypt_data
    company = Company.find_by_subdomain("priyankas-company")
    user = User.find_by_email(intercom_data.email)

    sign_in(user)

    # redirect_to board_url(company.boards.first, host: "#{company.subdomain}.lvh.me", port: 3000, protocol: "http")
    redirect_to board_url(company.boards.first, host: "7b5610e3.ngrok.io")
  end

  private

  def validate_request_and_decrtypt_data
    intercom_data = JSON.parse(params[:intercom_data])
    decoded_user = Base64.decode64(intercom_data["user"].encode('utf-8'))

    secret = "6bfef898-6d0d-4809-b920-584821a1f785"
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
