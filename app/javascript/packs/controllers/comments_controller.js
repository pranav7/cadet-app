import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["source"]

  connect() {
    console.log("I got connected! I am Comments Controller.")
  }

  editClickHandler() {
    $(`#edit-comment-${this.sourceTarget.dataset.value}-modal`).
      modal("show")
  }
}
