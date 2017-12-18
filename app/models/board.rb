class Board < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:scoped, :slugged, :history], scope: :company

  after_commit :after_create_tasks, on: :create

  belongs_to :company
  has_many :posts, dependent: :destroy

  validates :slug, presence: true, uniqueness: { scope: :company }
  validates :name, uniqueness: { case_sensitive: false, scope: :company }

  alias_attribute :title, :name

  def after_create_tasks
    notify_slack
  end

  private

  def notify_slack
    return if Rails.env.test?

    message = "*New Board added in ##{company.subdomain}"
    message << "\n_Name:_ #{title}"

    NotifySlackJob.perform_later(message)
  end
end
