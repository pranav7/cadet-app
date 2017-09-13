module Sluggable
  extend ActiveSupport::Concern

  def to_param
    return unless id
    [id, title.parameterize].join("-")
  end
end
