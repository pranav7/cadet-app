class TrialReminderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'mailers'

  def perform(company_id, user_id)
    company = Company.find company_id
    user = company.users.find user_id

    OnboardingMailer.trial_reminder(user, company).deliver unless company.paying?
  end
end
