module Admin::AdminHelper
  def intercom_hash
    {
      app_id: Rails.application.secrets.intercom[:app_id] || "zfmc7m57",
      user_id: current_user.id,
      email: current_user.email,
      name: current_user.name,
      created_at: current_user.created_at,
      role: current_user.membership_for(current_company).role,
      owner: current_user.membership_for(current_company).owner,
      primary_company_id: current_user.primary_company.try(:id),
      company: {
        company_id: current_company.id,
        name: current_company.name,
        subdomain: current_company.subdomain,
        plan: current_company.company_setting.billing_plan
      }
    }
  end
end
