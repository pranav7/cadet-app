module Helpers
  def visit_company(company, path = "/")
    app_host = URI.join("http://#{company.subdomain}.lvh.me").to_s
    using_app_host(app_host) do
      visit path
    end
  end

  def using_app_host(host)
    original_host = Capybara.app_host
    Capybara.app_host = host
    yield
  ensure
    Capybara.app_host = original_host
  end
end
