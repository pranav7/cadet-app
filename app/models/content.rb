class Content < ApplicationRecord
  belongs_to :parent, polymorphic: true, optional: true

  validates :body, presence: true

  def parsed
    context = {
      asset_root: "/images/",
      gfm: true,
      replace_br: true
    }

    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      HTML::Pipeline::AutolinkFilter,
      HTML::Pipeline::RougeFilter,
      HTML::Pipeline::NonLinkingMentionFilter
    ], context

    pipeline.call(body)[:output].to_s
  end

  def summary
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter
    ]

    parsed = pipeline.call(body)[:output].to_s
    ActionView::Base.full_sanitizer.sanitize(parsed).truncate(120)
  end
end
