# Preview all emails at http://localhost:3000/rails/mailers/welcome
class OnboardingMailerPreview < ActionMailer::Preview
  def welcome
    OnboardingMailer.welcome(User.last)
  end

  def trial_reminder
    OnboardingMailer.trial_reminder(User.last, User.last.companies.first)
  end

  def trial_expired
    OnboardingMailer.trial_expired(User.last, User.last.companies.first)
  end
end
