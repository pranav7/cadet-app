module ApplicationHelper
  # User this helper to render time in the view
  #   options :format [:short]
  def render_time(created_at, options = {})
    case
    when created_at > 1.week.ago
      return "#{time_ago_in_words(created_at)} ago"
    when created_at > 60.days.ago
      created_at.strftime("%e %b")
    else
      created_at.strftime("%e %b, %Y")
    end
  end

  def distance_of_time_to_expiry(company)
    return distance_of_time_in_words_to_now(company.company_setting.expires_at) if company.company_setting.expires_at

    "0 days"
  end
end
