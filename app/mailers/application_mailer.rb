class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@getcadet.com'
  layout 'mailer'

  def from_address
    "#{signature} <notifications@getcadet.com>"
  end

  def signature
    @signature ||= @user.customer_of?(@company) ? "#{@company.name}" : "Team Cadet"
  end
end
