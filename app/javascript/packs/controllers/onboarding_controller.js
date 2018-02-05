import { Controller } from "stimulus"

export default class extends Controller {
  openSignupModal() {
    $("#signup-modal")
      .modal({ duration: 250 })
      .modal("show")
  }

  openLoginModal() {
    $("#login-modal")
      .modal({ duration: 250 })
      .modal("show")
  }
}
