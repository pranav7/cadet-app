class Board < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:scoped, :slugged, :history], scope: :company

  after_commit :after_create_tasks, on: :create

  belongs_to :company
  has_many :posts, dependent: :destroy

  validates :slug, presence: true, uniqueness: { scope: :company }
  validates :name, uniqueness: { case_sensitive: false, scope: :company }

  alias_attribute :title, :name

  scope :non_public, -> { where(private: true) }
  scope :non_private, -> { where(private: false) }

  enum default_sort_order: %w(latest_activity most_voted) + Post.statuses.keys

  class << self
    def sort_order_collection
      default_sort_orders.map do |key, value|
        if Post.statuses.keys.include?(key)
          ["##{key}", key]
        else
          [key.titleize, key]
        end
      end
    end
  end

  def after_create_tasks
    notify_slack
  end

  private

  def notify_slack
    return if Rails.env.test?

    message = "*New Board - ##{company.subdomain}*"
    message << "\n_Name:_ #{title}"

    NotifySlackJob.perform_later(message)
  end
end
