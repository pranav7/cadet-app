require 'github/markup'

class Content < ApplicationRecord
  belongs_to :parent, polymorphic: true, optional: true

  validates :body, presence: true

  def parsed_markdown
    context = {
      asset_root: "/images/",
      gfm: true
    }

    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter,
      HTML::Pipeline::RougeFilter,
      HTML::Pipeline::EmojiFilter,
      HTML::Pipeline::AutolinkFilter,
    ], context

    pipeline.call(body)[:output].to_s
  end
end
