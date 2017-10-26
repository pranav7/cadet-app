require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:post) }
  it { should have_one(:content) }
  it { should belong_to(:user) }

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
      let(:post) { create :post }
      let(:user) { create :customer }
      let!(:admin) { create :admin, company: post.company }

      it "notifies all admins of the company" do
        expect { create :comment, post: post, user: user }
          .to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end
