import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["source"]

  editClickHandler() {
    $(`#edit-comment-${this.sourceTarget.dataset.value}-modal`).
      modal("show")
  }
}
