require "rails_helper"

RSpec.describe CommentNotificationMailer, type: :mailer do
  describe "#new_comment" do
    let(:user) { create :user }
    let(:mail) { CommentNotificationMailer.new_comment(comment, user) }

    context "new comment" do
      let(:comment) { create :comment }

      it "renders the correct headers" do
        expect(mail.subject).to eq("New Reply: #{comment.post.title}")
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["notifications@getcadet.com"])
      end
    end

    context "new note" do
      let(:comment) { create :comment, private: true }

      it "renders the correct headers" do
        expect(mail.subject).to eq("New Note: #{comment.post.title}")
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(["notifications@getcadet.com"])
      end
    end
  end
end
