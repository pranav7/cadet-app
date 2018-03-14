class Current < ActiveSupport::CurrentAttributes
  attribute :company, :user
  attribute :request_id, :user_agent, :ip_address
end
