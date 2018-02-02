import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log("Onboarding Connected", this.element)
  }

  handleClick() {
    $("#login-modal").modal("show", {
      dimmerSettings: { useCss: true }
    });
  }
}
