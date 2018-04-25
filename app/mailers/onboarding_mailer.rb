class OnboardingMailer < ApplicationMailer
  def welcome(user)
    @user = user

    mail(
      subject: "Welcome to Cadet",
      to: @user.formatted_address,
      from: "Pranav from Cadet <pranav@getcadet.com>"
    )
  end
end
