require 'rails_helper'

describe Comments::Destroy do
  let(:company) { create :company }
  let(:board) { create :board, company: company }
  let(:user) { create :user }
  let(:user2) { create :user }
  let(:post) { create :post, board: board }
  let(:comment) { create :comment, post: post, commenter: user }
  let(:comment_created_event) { create :comment_created_event, post: post, company: company, comment: comment }
  let!(:activity_log) { create :activity_log, :comment_created_event, event_id: comment_created_event.id, company: comment_created_event.company, post: comment_created_event.post }

  subject { described_class.run!(comment: comment) }

  before do
    Current.company = company
    Current.user = user
  end

  it "deletes the comment" do
    expect { subject }
      .to change(Comment, :count).by(-1)
                                 .and change(CommentCreatedEvent, :count).by(-1)
                                                                         .and change(ActivityLog, :count).by(-1)
  end

  context "validations" do
    before do
      Current.user = user2
    end

    it "validates that only the user who created the event can delete it" do
      expect { subject }.to raise_error(Errors::AdminLacksPermission)
    end
  end
end
