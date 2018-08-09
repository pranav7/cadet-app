require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:post) }
  it { should have_one(:content) }
  it { should belong_to(:commenter) }

  describe "#note?" do
    it "returns true for private notes" do
      comment = build :comment
      comment.private = true
      comment.save

      expect(comment.note?).to eq(true)
    end

    it "reutrns false for public comments" do
      comment = create :comment
      expect(comment.note?).to eq(false)
    end
  end

  describe "After Create" do
    before :each do
      Timecop.freeze(1.day.ago) do
        @post = create :post
      end

      Timecop.return
    end

    it "should update the last_activity_at attribute of post" do
      comment = build :comment, post: @post

      comment_created_at = Time.zone.now
      Timecop.freeze(comment_created_at) do
        comment.save
      end

      Timecop.return
      @post.reload

      expect(@post.last_activity_at.utc.strftime("%a, %b %e, %Y at%l:%M %p")).
        to eq(comment_created_at.utc.strftime("%a, %b %e, %Y at%l:%M %p"))
    end

    context "Email Notification" do
      let(:board) { create :board }
      let(:company) { board.company }
      let!(:admin) { create :admin, company: company }

      context "customer adds a comment" do
        let(:requester) { create :customer }
        let(:post) { create :post, requester: requester, board: board }
        let!(:admin2) { create :admin, company: company }
        let(:customer) { create :customer }

        it "notifies mentionees" do
          mailer = double(deliver_later: true)
          expect(mailer).to receive(:deliver_later)
          expect(CommentNotificationMailer).to receive(:mention).
            once.with(kind_of(Comment), admin2).and_return(mailer)

          create :comment, post: post, commenter: customer,
            content_attributes: { body: "Hi, @#{admin2.username}." }
        end

        it "notifies all admins of the company" do
          mailer = double(deliver_later: true)
          expect(mailer).to receive(:deliver_later).twice
          expect(CommentNotificationMailer).to receive(:new_comment).
            twice.and_return(mailer)

          create :comment, post: post, commenter: customer
        end

        it "does not notify admin of new comment if he is already mentioned" do
          mailer = double(deliver_later: true)
          expect(mailer).to receive(:deliver_later).twice

          expect(CommentNotificationMailer).to receive(:new_comment).
            once.with(kind_of(Comment), admin).and_return(mailer)
          expect(CommentNotificationMailer).to receive(:mention).
            once.with(kind_of(Comment), admin2).and_return(mailer)

          create :comment, post: post, commenter: customer,
            content_attributes: { body: "Hi, @#{admin2.username}." }
        end
      end

      context "admin adds a comment" do
        context "requester is a customer" do
          let(:requester) { create :customer }
          let(:post) { create :post, requester: requester, board: board }

          it "notifies requester of new comment unless they are mentioned" do
            mailer = double(deliver_later: true)
            expect(mailer).to receive(:deliver_later).once

            expect(CommentNotificationMailer).to receive(:new_comment).
              once.with(kind_of(Comment), requester).and_return(mailer)
            expect(CommentNotificationMailer).to receive(:mention).
              exactly(0).times.with(kind_of(Comment), requester)

            create :comment, post: post, commenter: admin
          end

          it "notifies requester of mention if they are mentioned" do
            mailer = double(deliver_later: true)
            expect(mailer).to receive(:deliver_later).once

            expect(CommentNotificationMailer).to receive(:new_comment).
              exactly(0).times.with(kind_of(Comment), requester)
            expect(CommentNotificationMailer).to receive(:mention).
              once.with(kind_of(Comment), requester).and_return(mailer)

            create :comment, post: post, commenter: admin,
              content_attributes: { body: "Hey @#{requester.username}" }
          end

          context "post belongs to a private board" do
            let(:board) { create :board, private: true }

            it "does not notify requester of new comment" do
              mailer = double(deliver_later: true)
              expect(mailer).to receive(:deliver_later).exactly(0).times

              expect(CommentNotificationMailer).to receive(:new_comment).
                exactly(0).times.with(kind_of(Comment), requester)

              create :comment, post: post, commenter: admin
            end

            it "does not notify requester even if they are mentioned" do
              mailer = double(deliver_later: true)
              expect(mailer).to receive(:deliver_later).exactly(0).times

              expect(CommentNotificationMailer).to receive(:new_comment).
                exactly(0).times.with(kind_of(Comment), requester)
              expect(CommentNotificationMailer).to receive(:mention).
                exactly(0).times.with(kind_of(Comment), requester)

              create :comment, post: post, commenter: admin,
                content_attributes: { body: "Hey @#{requester.username}" }
            end
          end
        end

        context "notifications to other admins" do
          let(:post) { create :post, requester: admin, board: board }
          let!(:admin2) { create :admin, company: company }

          it "notifies mentionees" do
            mailer = double(deliver_later: true)
            expect(mailer).to receive(:deliver_later)
            expect(CommentNotificationMailer).to receive(:mention).
              once.with(kind_of(Comment), admin2).and_return(mailer)

            create :comment, post: post, commenter: admin,
              content_attributes: { body: "Hi, @#{admin2.username}." }
          end

          it "doesn't notify all admins unless they are mentioned" do
            admin3 = create :admin, company: post.company

            mailer = double(deliver_later: true)
            expect(mailer).to receive(:deliver_later)
            expect(CommentNotificationMailer).to receive(:mention).
              once.with(kind_of(Comment), admin2).and_return(mailer)
            expect(CommentNotificationMailer).to receive(:new_comment).
              exactly(0).times.with(kind_of(Comment), admin3)

            create :comment, post: post, commenter: admin,
              content_attributes: { body: "Hi, @#{admin2.username}." }
          end
        end
      end

      context "admin adds a note" do
        let(:post) { create :post, requester: (create :customer), board: board }

        it "notifies mentionees" do
          admin2 = create :admin, company: post.company
          mailer = double(deliver_later: true)
          expect(mailer).to receive(:deliver_later).once

          expect(CommentNotificationMailer).to receive(:mention).
            once.with(kind_of(Comment), admin2).and_return(mailer)

          create :comment, post: post, commenter: admin, private: true,
            content_attributes: { body: "Hey @#{admin2.username}" }
        end

        it "does not notify requester" do
          expect(CommentNotificationMailer).to receive(:new_comment).
            exactly(0).times.with(kind_of(Comment), post.requester)

          create :comment, post: post, commenter: admin, private: true
        end

        it "does not notify requester even if they are mentioned" do
          expect(CommentNotificationMailer).to receive(:mention).
            exactly(0).times.with(kind_of(Comment), post.requester)

          create :comment, post: post, commenter: admin, private: true,
            content_attributes: { body: "Hi, @#{post.requester.username}." }
        end
      end
    end
  end

  describe ".create_from_email" do
    let(:user) { create :user }
    let(:post) { create :post }
    let(:email) do
      Hashie::Mash.new({
        From: user.email,
        StrippedTextReply: "this is the body of the comment"
      })
    end

      
    it "creates a comment from an incoming email object" do
      expect {
        Comment.create_from_email(email, post)
      }.to change { Comment.count }
    end

    it "doesn't create a comment if user does not exist" do
      email = Hashie::Mash.new({ StrippedTextReply: "this is a comment" })

      expect {
        Comment.create_from_email(email, post)
      }.to_not change { Comment.count }
    end
  end
end
