require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe Vote, "Association" do
    it { should belong_to :post }
    it { should belong_to :user }
  end

  describe "After Create" do
    before :each do
      Timecop.freeze(1.day.ago) do
        @post = create :post
      end

      Timecop.return
    end

    it "should update the last_activity_at attribute of post" do
      vote = build :vote, post: @post

      vote_created_at = Time.zone.now
      Timecop.freeze(vote_created_at) do
        vote.save
      end

      Timecop.return
      @post.reload

      expect(@post.last_activity_at.utc.strftime("%a, %b %e, %Y at%l:%M %p")).to eq(vote_created_at.utc.strftime("%a, %b %e, %Y at%l:%M %p"))
    end
  end
end
