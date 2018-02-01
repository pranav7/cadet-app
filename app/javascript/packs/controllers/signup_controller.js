import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "companyName", "subdomain" ]

  connect() {
    this.setupFormValidations()
  }

  companyNameChangeListener(event) {
    if(this._shouldUpdate(event.which)) {
      this.subdomainTarget.value = this.companyNameTarget.value.replace(/\s+/g, '-').toLowerCase()
    }
  }

  _shouldUpdate(charCode) {
    return (charCode >= 65 && charCode <= 90) ||
      (charCode >= 97 && charCode <= 122) ||
      (charCode == 32) ||
      (charCode == 8)
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
