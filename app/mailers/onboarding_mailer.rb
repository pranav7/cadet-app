class OnboardingMailer < ApplicationMailer
  def welcome(user)
    @user = user

    mail(
      subject: "Welcome to Cadet",
      to: @user.formatted_address,
      from: "Pranav from Cadet <pranav@getcadet.com>"
    )
  end

  def trial_reminder(user, company)
    @user = user
    @company = company

    mail(
      subject: "Checking-in on your Cadet Trial",
      to: @user.formatted_address,
      from: "Pranav from Cadet <pranav@getcadet.com>"
    )
  end

  def trial_expired(user, company)
    @user = user
    @company = company

    mail(
      subject: "Your Cadet Trial & Subscription",
      to: @user.formatted_address,
      from: "Pranav from Cadet <pranav@getcadet.com>"
    )
  end
end
