class IntercomIntegrationsController < ApplicationController
  before_action :authenticate_user!

  def load_accounts
    company, intercom = extract_company_and_intercom_client
    return unless intercom

    Rails.logger.info("Loading intercom accounts for company #{company.name}...")
    accounts = company.accounts
    account_identifiers = accounts.map(&:source_identifier).to_set
    companies_to_add = intercom.companies.scroll.reject { |c| account_identifiers.include?(c.name) }
    Account.transaction do
      num_companies_saved = companies_to_add.map { |c| convert_to_account_and_save(c) }.sum
      Rails.logger.info("Attempted to save #{companies_to_add.length} companies. Saved #{num_companies_saved} companies")
    end
    render json: { success: true }
  end

  def load_customers
    company, intercom = extract_company_and_intercom_client
    return unless intercom

    Rails.logger.info("Loading intercom customers for company #{company.name}...")
    existing_user_emails = User.all.map(&:email).to_set
    users_to_add = intercom.contacts.all.reject { |c| existing_user_emails.include?(c.email) }
    User.transaction do
      num_users_saved = users_to_add.map { |u| create_user(u) }.sum
      Rails.logger.info("Attempted to save #{users_to_add.length} users. Saved #{num_users_saved} users")
    end
    render json: { success: true }
  end

  def load_membership
    company, intercom = extract_company_and_intercom_client
    return unless intercom

    Rails.logger.info("Setting account and customer membership for company #{company.name}...")
    all_user_hash = User.all.map { |u| [u.email, u] }.to_h

    # Setup account membership
    valid_contacts = intercom.contacts.all.select { |c| all_user_hash.include?(c.email) }
    AccountMembership.transaction do
      num_account_memberships_added = valid_contacts.map { |c| add_account_membership_for_user(c, all_user_hash[c.email]) }.sum
      Rails.logger.info("Attempted to create account memberships for #{valid_contacts.length} users. Saved #{num_account_memberships_added} account memberships")
    end

    # Setup customer membership
    existing_customer_emails = company.customers.map(&:email).to_set
    # Check if we haven't added it yet and if the user exists
    customers_to_add = intercom.contacts.all.select { |c| !existing_customer_emails.include?(c.email) && all_user_hash.include?(c.email) }
    Membership.transaction do
      num_memberships_added = customers_to_add.map { |c| add_user_as_customer(company, all_user_hash[c.email]) }.sum
      Rails.logger.info("Attempted to create #{customers_to_add.length} customer memberships. Saved #{num_memberships_added} memberships")
    end
    render json: { success: true }
  end

  def extract_company_and_intercom_client
    company = Company.find(params[:company_id])
    intercom_access_token = company.company_setting.intercom_access_token
    intercom = nil
    intercom = Intercom::Client.new(token: intercom_access_token) if intercom_access_token
    [company, intercom]
  end

  def convert_to_account_and_save(intercom_company)
    a = current_company.accounts.new
    a.name = intercom_company.name
    a.domain = intercom_company.name
    a.mrr = intercom_company.monthly_spend
    a.paying = a.mrr.present? && a.mrr.positive?
    a.source = 'Intercom'
    a.source_identifier = intercom_company.id
    a.save! ? 1 : 0
  end

  def create_user(user)
    if user.email && user.name
      u = User.new
      u.email = user.email
      u.name = user.name
      u.password = Devise.friendly_token[0, 20]
      u.save! ? 1 : 0
    else
      0
    end
  end

  def add_account_membership_for_user(intercom_user, user_model)
    memberships_saved = 0
    intercom_user.companies.each do |c|
      account = Account.find_by_source_identifier(c.id)
      account_membership = account.account_memberships.new(user: user_model)
      memberships_saved += 1 if account_membership.save
    end
    memberships_saved
  end

  def add_user_as_customer(company, user_to_add)
    Membership.create(user: user_to_add, company: company, primary: true) ? 1 : 0
  end
end
