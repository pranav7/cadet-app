require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:post) }
  it { should have_one(:content) }
  it { should belong_to(:user) }

  describe "#note?" do
    it "returns true for private " do
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

      expect(@post.last_activity_at.utc.strftime("%a, %b %e, %Y at%l:%M %p")).to eq(comment_created_at.utc.strftime("%a, %b %e, %Y at%l:%M %p"))
    end

    context "Email Notification" do
      let(:requester) { create :customer }
      let(:post) { create :post, requester: requester }
      let!(:admin) { create :admin, company: post.company }
      let!(:admin2) { create :admin, company: post.company }

      context "customer comments" do
        let(:customer) { create :customer }

        it "notifies all admins of the company" do
          expect { create :comment, post: post, user: customer }
            .to have_enqueued_job.on_queue('mailers').exactly(:twice)
        end
      end

      context "staff adds note" do
        it "notifies all admins of the company" do
          expect { create :comment, post: post, user: admin, private: true }
            .to have_enqueued_job.on_queue('mailers').exactly(:once)
        end
      end

      context "staff comments" do
        it "notifies post requester and other staff members" do
          expect { create :comment, post: post, user: admin }
            .to have_enqueued_job.on_queue('mailers').exactly(:twice)
        end

        it "does not notify if staff adds a note" do
          expect { create :comment, post: post, user: admin, private: true }
            .to have_enqueued_job.on_queue('mailers').exactly(:once)
        end
      end
    end
  end
end
