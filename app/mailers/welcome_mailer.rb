class WelcomeMailer < ApplicationMailer
  def welcome_owner(user)
    @user = user

    mail(
      subject: "Welcome to Cadet",
      to: @user.formatted_address,
      from: "Pranav from Cadet <pranav@getcadet.com>"
    )
  end
end
