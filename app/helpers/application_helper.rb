module ApplicationHelper
  def render_time(created_at)
    if created_at > 1.week.ago
      "#{time_ago_in_words(created_at)} ago"
    else
      created_at.strftime("%e %B, %Y")
    end
  end
end
