class Content < ApplicationRecord
  belongs_to :parent, polymorphic: true, optional: true

  validates :body, presence: true

  def parsed
    context = {
      asset_root: "/images/",
      gfm: true,
      replace_br: true,
      username_pattern: /(?<!\w)@([a-z0-9-]+)?/
    }

    parsed_body = HTML::Pipeline::MentionFilter.mentioned_logins_in(body) do |match, login, is_mentioned|
      "<strong>@#{login}</strong>"
    end

    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      HTML::Pipeline::AutolinkFilter,
      HTML::Pipeline::RougeFilter
    ], context

    pipeline.call(parsed_body)[:output].to_s
  end

  def summary
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter
    ]

    parsed = pipeline.call(body)[:output].to_s
    ActionView::Base.full_sanitizer.sanitize(parsed).truncate(120)
  end
end
