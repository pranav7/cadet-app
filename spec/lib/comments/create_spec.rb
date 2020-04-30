require 'rails_helper'

describe Comments::Create do
  let(:company) { create :company }
  let(:board) { create :board, company: company }
  let(:user) { create :user }
  let(:admin) { create :admin, company: company }
  let(:post) { create :post, board: board }
  let(:content) { { "body" => "Test Body" } }
  let(:is_private) { false }

  subject { described_class.run!(post: post, is_private: is_private, content: content) }

  before do
    Current.company = company
    Current.user = user
  end

  it "creates a comment" do
    expect { subject }.to change(Comment, :count).by(1)
    comment = Comment.last
    expect(comment.commenter).to eq(user)
    expect(comment.content.body).to eq("Test Body")
    expect(comment.post).to eq(post)
    expect(comment.private).to eq(is_private)
  end

  it "creates an activity log" do
    expect { subject }.to change(ActivityLog, :count).by(1)
  end

  it "records a comment created event" do
    expect { subject }.to change(CommentCreatedEvent, :count).by(1)

    activity_log = ActivityLog.find_by(post_id: post.id, company_id: company.id)
    comment_created_event = activity_log.event

    expect(comment_created_event).to_not eq(nil)
    expect(comment_created_event.comment_id).to_not eq(nil)
    expect(comment_created_event.post_id).to_not eq(nil)
    expect(comment_created_event.company_id).to_not eq(nil)
  end

  context "when creating a note" do
    before do
      Current.user = admin
    end

    let(:is_private) { true }
    it "records the correct visibility" do
      subject

      activity_log = ActivityLog.find_by(post_id: post.id)
      expect(activity_log.visibility).to eq(Constants::Visibility::PRIVATE)
    end
  end

  context "when creating a comment" do

    it "records the correct visibility" do
      subject

      activity_log = ActivityLog.find_by(post_id: post.id)
      expect(activity_log.visibility).to eq(Constants::Visibility::PUBLIC)
    end
  end

  context "validations" do
    before do
      Current.user = admin
    end
    let(:is_private) { true }
    it "should not throw Insufficient permissions error" do
      subject

      expect { subject }.to_not raise_error(Errors::AdminLacksPermission)
    end
  end
end