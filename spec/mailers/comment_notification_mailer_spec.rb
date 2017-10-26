require "rails_helper"

RSpec.describe CommentNotificationMailer, type: :mailer do
  describe "#new_comment" do
    let(:user) { create :user }
    let(:comment) { create :comment }
    let(:mail) { CommentNotificationMailer.new_comment(user, comment) }

    it "renders the headers" do
      expect(mail.subject).to eq("New Comment on #{comment.post.title}")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["hello@getcadet.com"])
    end
  end
end
