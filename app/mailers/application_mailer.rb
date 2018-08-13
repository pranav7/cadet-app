class ApplicationMailer < ActionMailer::Base
  require 'mail'
  layout 'mailer'

  def from_address
    address = Mail::Address.new "notifications@getcadet.com"
    address.display_name = signature
    address.format
  end

  def signature
    @signature ||= @user.customer_of?(@company) ? "#{@company.name}" : "Team Cadet"
  end

  def reply_to_address(type, post_id)
    "#{Rails.application.secrets.postmark[:reply_to_hash]}+#{type}-#{post_id}@#{Rails.application.secrets.postmark[:inbound_domain]}"
  end
end
