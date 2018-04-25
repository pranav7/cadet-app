# Preview all emails at http://localhost:3000/rails/mailers/welcome
class OnboardingMailerPreview < ActionMailer::Preview
  def welcome
    OnboardingMailer.welcome(User.last)
  end
end
