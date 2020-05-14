require 'rails_helper'

RSpec.describe CommentCreatedEvent, type: :model do
  describe "#activity_log" do
    let(:comment_created_event) { create :comment_created_event }
    let!(:activity_log) { create :activity_log, :comment_created_event, event_id: comment_created_event.id, company: comment_created_event.company, post: comment_created_event.post }

    subject { comment_created_event.activity_log }
    it { is_expected.to eq(activity_log) }
  end
end
