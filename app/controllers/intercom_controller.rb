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
                "url": "https://d6499de5.ngrok.io/intercom/sheets"
              }
            }
          ]
        }
      }
    }
  end

  def sheets
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

    intercom_user = JSON.parse(decipher.update(ciphertext) + decipher.final)
    user = User.find_by_email(intercom_user["email"])
    sign_in(user)

    @board = Board.find(1)
    @post = @board.posts.new
    @post.build_content

    response.headers["X-Frame-Options"] = "ALLOW-FROM https://intercom-sheets.com"
    render template: "boards/show"
  end
end
