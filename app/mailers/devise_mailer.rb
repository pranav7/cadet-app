class DeviseMailer < Devise::Mailer
  layout 'mailer'

  def invitation_instructions(record, token, options = {})
    @resource = record
    @company = @resource.memberships.first.company
    @host = @company.host
    @invited_by = @resource.invited_by
    @no_signatures = true

    options[:subject] = "Help us make #{@company.name} better"
    options[:from] = from_address(@invited_by.name)

    super
  end

  private

  def from_address(display_name)
    address = Mail::Address.new "notifications@getcadet.com"
    address.display_name = display_name
    address.format
  end
end
