class ApplicationMailer < ActionMailer::Base
  require 'mail'
  # default from: 'notifications@getcadet.com'
  layout 'mailer'

  def from_address
    address = Mail::Address.new "notifications@getcadet.com"
    address.display_name = signature
    address.format
  end

  def signature
    @signature ||= @user.customer_of?(@company) ? "#{@company.name}" : "Team Cadet"
  end
end
