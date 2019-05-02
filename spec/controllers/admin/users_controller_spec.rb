require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe "PUT update" do
    let(:company) { create :company }
    let(:admin) { create :admin, company: company }
    let(:user) { create :customer, company: company }

    context "admin of current company signed in" do
      before :each do
        request.host = "#{company.subdomain}.example.com"
        sign_in admin
      end

      it "returns a successful response" do
        put :update, params: { id: user.id, user: { email: "test@123.com" } }

        expect(response).to redirect_to(admin_user_path(user))
      end

      it "successfully updates attributes" do
        put :update, params: { id: user.id, user: { email: "test@123.com", first_name: "Prinka" } }

        user.reload
        expect(user.email).to eq('test@123.com')
        expect(user.first_name).to eq('Prinka')
      end
    end

    context "non-admin signed in" do
      let(:other_customer) { create :customer }

      before :each do
        request.host = "#{company.subdomain}.example.com"
        sign_in other_customer
      end

      it "does not allow to update user" do
        put :update, params: { id: user.id, user: { email: "test@123.com" } }

        user.reload
        expect(user.email).to_not eq('test@123.com')
      end
    end

    context "user's primary company is not same current_user's company" do
      let(:company) { create :company }
      let(:admin) { create :admin, company: company }
      let(:user) { create :customer, company: company, not_primary: true }

      before :each do
        request.host = "#{company.subdomain}.example.com"
        sign_in admin
      end

      it "only allows to update role and no other attribute" do
        put :update, params: { id: user.id, user: { role: "admin" } }

        user.reload
        expect(user.admin_of?(company)).to eq(true)
      end
    end
  end
end
