class TrialExpiredWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'mailers'

  def perform(company_id, user_id)
    company = Company.find company_id
    user = company.users.find user_id

    unless company.paying?
      OnboardingMailer.trial_expired(user, company).deliver
    end
  end
end
