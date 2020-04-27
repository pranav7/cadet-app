require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  describe "#event" do
    let(:status_changed_event) { create :status_changed_event }
    let(:activity_log) { create :activity_log, :status_changed, event_id: status_changed_event.id }

    subject { activity_log.event }

    it { is_expected.to eq(status_changed_event) }
  end
end
