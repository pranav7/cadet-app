import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log("Onboarding Connected", this.element)
  }

  openSignupModal() {
    $("#signup-modal").modal("show", {
      dimmerSettings: { useCss: true }
    });
  }

  openLoginModal() {
    $("#login-modal").modal("show", {
      dimmerSettings: { useCss: true }
    });
  }
}
