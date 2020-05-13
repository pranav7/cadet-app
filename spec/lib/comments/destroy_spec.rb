require 'rails_helper'

describe Comments::Destroy do
  let(:company) { create :company }
  let(:board) { create :board, company: company }
  let(:user) { create :user }
  let(:admin) { create :admin, company: company }
  let(:post) { create :post, board: board }
  let(:comment) { create :comment, post: post, commenter: user }
  let(:comment_created_event) { create :comment_created_event, post: post, company: company, comment: comment }
  let(:activity_log) { create :activity_log, post: post, company: company }

  subject { described_class.run!(comment: comment) }

  before do
    Current.company = company
    Current.user = user
  end

  it "deletes the comment" do
    binding.pry
    expect { subject }.to change(Comment, :count).by(1)
    # expect(comment.commenter).to eq(user)
    # expect(comment.content.body).to eq("Test Body")
    # expect(comment.post).to eq(post)
    # expect(comment.private).to eq(is_private)
  end
end