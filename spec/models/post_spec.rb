require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Associations" do
    it { should have_one(:content) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should belong_to(:user) }
    it { should belong_to(:board) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }

    it "has a valid factory" do
      expect(build(:post)).to be_valid
    end
  end

  describe "#status" do
    it "should default to open" do
      post = create :post
      expect(post.open?).to eq(true)
    end
  end

  describe "Before Validation" do
    it "sets last_activity_at" do
      post = create :post
      expect(post.last_activity_at).to_not be_nil
    end
  end

  describe "After Update" do
    context "status changed" do
      let(:post) { build :post }

      before do
        @post_created_at = 1.day.ago
        Timecop.freeze(@post_created_at) do
          post.save
        end

        Timecop.return
      end

      it "updates last_activity_at" do
        status_changed_at = Time.zone.now
        Timecop.freeze(status_changed_at) do
          post.developing!
        end
        Timecop.return

        expect(post.last_activity_at.utc.strftime("%a, %b %e, %Y at%l:%M %p")).to eq(status_changed_at.utc.strftime("%a, %b %e, %Y at%l:%M %p"))
      end
    end
  end
end
