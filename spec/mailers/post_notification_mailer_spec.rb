require "rails_helper"

RSpec.describe PostNotificationMailer, type: :mailer do
  describe "#new_post" do
    let(:user) { create :user }
    let(:requester) { create :customer }
    let(:post) { create :post, requester: requester }
    let(:mail) { PostNotificationMailer.new_post(post, user) }

    it "renders the headers" do
      expect(mail.subject).to eq("New Post #{post.title} in #{post.board.name}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["notifications@getcadet.com"])
    end
  end
end
