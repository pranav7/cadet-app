module ApplicationHelper
  # User this helper to render time in the view
  #   options :format [:short]
  def render_time(created_at, options = {})
    format = options.delete(:format)

    case
    when created_at > 1.week.ago
      return "#{time_ago_in_words(created_at)} ago"
    when created_at > 1.year.ago
      if format && format == :short
        return created_at.strftime("%e %b")
      else
        return created_at.strftime("%e %B, %Y")
      end
    else
      if format && format == :short
        return created_at.strftime("%e %b, %y")
      else
        return created_at.strftime("%e %B, %Y")
      end
    end
  end

  def distance_of_time_to_expiry(company)
    if company.company_setting.expires_at
      return distance_of_time_in_words_to_now(company.company_setting.expires_at)
    end

    "0 days"
  end
end
