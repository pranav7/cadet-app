module ApplicationHelper
  # User this helper to render time in the view
  #   options :format [:short]
  def render_time(created_at, options = {})
    format = options.delete(:format)

    case
    when created_at > 1.week.ago
      return "#{time_ago_in_words(created_at)} ago"
    when created_at > 1.year.ago
      return created_at.strftime("%e %b") if format && format == :short

      created_at.strftime("%e %B, %Y")
    else
      return created_at.strftime("%e %b, %y") if format && format == :short

      created_at.strftime("%e %B, %Y")
    end
  end

  def distance_of_time_to_expiry(company)
    return distance_of_time_in_words_to_now(company.company_setting.expires_at) if company.company_setting.expires_at

    "0 days"
  end
end
