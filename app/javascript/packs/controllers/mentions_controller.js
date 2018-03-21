import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.getUsers()
  }

  autocomplete() {
    $("#new-comment-el").atwho({
      at: "@",
      displayTpl: "<li><strong>${name}</strong> <small>${username}</small></li>",
      insertTpl: "@${username}",
      data: this.users
    })

    $("#new-note-el").atwho({
      at: "@",
      displayTpl: "<li><strong>${name}</strong> <small>${username}</small></li>",
      insertTpl: "@${username}",
      data: this.users
    })
  }

  getUsers() {
    axios({
      method: "GET",
      url: "/users",
      headers: {
        'Content-Type': "application/json",
        'Accept': "application/json",
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
      }
    })
    .then(response => {
      this.users = response.data.users
      this.autocomplete()
    })
  }
}
