import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'postTitle', 'postDesc' ]

  connect() {
    if (Cookies.get("postTitle")) {
      this.postTitleTarget.value = Cookies.get("postTitle")
      Cookies.remove("postTitle")
    }

    if (Cookies.get("postDesc")) {
      this.postDescTarget.value = Cookies.get("postDesc")
      Cookies.remove("postDesc")
    }
  }

  handleCreatePost() {
    Cookies.set("postTitle", this.postTitleTarget.value)
    Cookies.set("postDesc", this.postDescTarget.value)
    this.openLoginModal()
  }

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
