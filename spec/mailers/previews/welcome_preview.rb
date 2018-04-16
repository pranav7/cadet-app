# Preview all emails at http://localhost:3000/rails/mailers/welcome
class WelcomePreview < ActionMailer::Preview
  def welcome_owner
    WelcomeMailer.welcome_owner(User.last)
  end
end
