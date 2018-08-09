require 'rails_helper'

RSpec.describe InboundEmailsController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:board) { create :board, company: company }
  let(:post_record) { create :post, board: board }

  before :each do
    request.host = "app.example.com"
  end

  describe "#consume" do
    it "returns a successful response" do
      email_raw = file_fixture("inbound_email.json").read
      email_raw.gsub!(/{{FromEmail}}/, user.email)
      email_raw.gsub!(/{{FromName}}/, user.name)
      email_raw.gsub!(/{{NotificationType}}/, "comment")
      email_raw.gsub!(/{{PostId}}/, post_record.id.to_s)

      post :consume, body: email_raw, format: :json

      expect(response).to be_successful
    end

    it "creates a comment" do
      email_raw = file_fixture("inbound_email.json").read
      email_raw.gsub!(/{{FromEmail}}/, user.email)
      email_raw.gsub!(/{{FromName}}/, user.name)
      email_raw.gsub!(/{{NotificationType}}/, "comment")
      email_raw.gsub!(/{{PostId}}/, post_record.id.to_s)

      expect {
        post :consume, body: email_raw, format: :json
      }.to change { post_record.comments.count }
    end
  end
end


