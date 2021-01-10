class ChangelogPost < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true

    VALID_STATUSES = ['New', 'Improvement', 'Bug']
    validates :status, presence: true, inclusion: { in: VALID_STATUSES }

    def parsed
        pipeline = HTML::Pipeline.new [
          HTML::Pipeline::MarkdownFilter,
          HTML::Pipeline::SanitizationFilter
        ]
        pipeline.call(content)[:output].to_s
    end
    
end
