require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Associations" do
    it { should have_one(:content) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should belong_to(:requester).optional(true) }
    it { should belong_to(:board) }
    it { should belong_to(:added_by).optional(true) }
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

  describe "#participants" do
    let(:post) { create :post }

    it "returns a list of all commenters and voters" do
      vote = create :vote, post: post
      comment = create :comment, post: post

      expect(post.participants.include?(vote.user)).to eq(true)
      expect(post.participants.include?(comment.user)).to eq(true)
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

  describe "After Create" do
    let!(:company) { create :company }
    let!(:admin) { create :admin, company: company }
    let(:board) { create :board, company: company }

    describe "new post created" do
      it "sends email notification to all admins" do
        expect { create :post, board: board }
          .to have_enqueued_job.on_queue('mailers').exactly(:once)
      end
    end

    describe "Status Change Notifications" do
      let(:admin) { create :admin, company: company }
      let(:customer) { create :customer, company: company }

      it "should not notify user who is changing the post" do
        Current.user = admin

        post = create :post
        create :vote, post: post, user: admin

        expect {
          post.update_attributes(status: "developing")
        }.to have_enqueued_job.on_queue("mailers").exactly(0)
      end

      context "public board" do
        it "should notify all participants" do
          post = create :post, requester: customer
          create :vote, post: post, user: customer
          create :comment, post: post

          expect {
            post.update_attributes(status: "developing")
          }.to have_enqueued_job.on_queue('mailers').exactly(:twice)
        end
      end

      context "private board" do
        let(:board) { create :board, company: company, private: true }

        it "should not notify customers" do
          post = create :post, board: board, requester: customer
          create :vote, post: post, user: customer

          double(deliver_later: true)
          expect(PostNotificationMailer).to receive(:status_changed)
            .exactly(0).times.with(post, "developing", customer)

          post.update_attributes(status: "developing")
        end
      end
    end
  end

  describe "Scopes" do
    describe ".most_voted" do
      before :each do
        @post1 = create :post
        create_list :vote, 4, post: @post1

        @post2 = create :post
        create_list :vote, 3, post: @post2

        @post3 = create :post
        create_list :vote, 2, post: @post3

        @post4 = create :post
        create :vote, post: @post4
      end

      it "returns the posts with most votes first" do
        expect(Post.most_voted).to eq([@post1, @post2, @post3, @post4])
      end

      it "should not return released or closed posts" do
        @post3.released!
        @post4.closed!

        expect(Post.most_voted).to eq([@post1, @post2])
      end
    end
  end

  describe ".search" do
    it "returns a list of posts that match the term" do
      create :post, title: "Title 1"
      create :post, title: "Title 2"
      create :post, title: "Unrelated"

      expect(Post.search(term: "title").count).to eq(2)
    end
  end
end
