require 'rails_helper'

describe Posts::Update do
  let(:company) { create :company }
  let(:board) { create :board, company: company }
  let(:admin) { create :admin, company: company }
  let(:post) { create :post, board: board }
  let(:title) { "Test Title" }
  let(:content) { { body: "Test Body" } }
  let(:status) { Post.statuses[:developing] }
  let(:requester) { create :user }

  subject do
    described_class.run!(
      post: post,
      status: status,
      title: title,
      requester_id: requester.id,
      content: content
    )
  end

  before do
    Current.user = admin
    Current.company = company
  end

  it "successfully updates the attributes" do
    subject

    expect(post.title).to eq(title)
    expect(post.developing?).to eq(true)
    expect(post.content.body).to eq(content[:body])
    expect(post.requester).to eq(requester)
  end

  context "when the status is being updated" do
    it "records an activity log for status changed" do
      expect { subject }.to change(ActivityLog, :count).by(1)

      activity_log = ActivityLog.find_by(post_id: post.id, company_id: company.id)

      expect(activity_log).to_not eq(nil)
      expect(activity_log.event_id).to_not eq(nil)
      expect(visibility).to eq(Constants::Visibility::PUBLIC)
    end

    it "the status changed event records the correct values" do
      expect { subject }.to change(StatusChangedEvent, :count).by(1)

      activity_log = ActivityLog.find_by(post_id: post.id, company_id: company.id)
      status_changed_event = activity_log.event

      expect(status_changed_event).to_not eq(nil)
      expect(status_changed_event.old_value).to eq(Post.statuses[post.status])
      expect(status_changed_event.new_value).to eq(status)
    end
  end

  context "when requester is changed" do
    it "recoreds a new vote"
  end

  context "validations" do
  end
end
