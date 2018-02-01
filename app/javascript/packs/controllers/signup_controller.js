import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "companyName", "subdomain" ]

  connect() {
    this.setupFormValidations()
  }

  companyNameChangeListener(event) {
    this.subdomainTarget.value = this.companyNameTarget.value.replace(/\s+/g, '-').replace(/[^a-zA-Z0-9-]+/g, '').toLowerCase()
  }

  setupFormValidations() {
    $("#new_user").form({
      fields: {
        email: ['empty', 'email'],
        subdomain: ['empty']
      }
    });
  }
}
