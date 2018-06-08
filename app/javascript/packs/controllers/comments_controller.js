import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    console.log("I got connected! I am Comments Controller.")
  }

  editClickHandler() {
    console.log("Edit Clicked!")
  }
}
