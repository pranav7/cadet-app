import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["newNote", "newComment"]

  connect() {
    if (this.hasNewCommentTarget) {
      this.autoCompleteForComments()
    }

    if (this.hasNewNoteTarget) {
      this.autoCompleteForNotes()
    }
  }

  autoCompleteForComments() {
    this.getUsers((users) => {
      $(this.newCommentTarget).atwho({
        at: "@",
        displayTpl: "<li><strong>${name}</strong> <small>${username}</small></li>",
        insertTpl: "@${username}",
        data: users
      })
    })
  }

  autoCompleteForNotes() {
    this.getUsers((users) => {
      $(this.newNoteTarget).atwho({
        at: "@",
        displayTpl: "<li><strong>${name}</strong> <small>${username}</small></li>",
        insertTpl: "@${username}",
        data: users
      })
    }, { admins: true })
  }

  getUsers(callback = null, params = {}) {
    let url = null

    if (_.isEmpty(params)) {
      url = "/users"
    } else {
      url = `/users?${$.param(params)}`
    }

    axios({
      method: "GET",
      url: url,
      headers: {
        'Content-Type': "application/json",
        'Accept': "application/json",
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
      }
    })
    .then(response => {
      if (!_.isNull(callback)) {
        callback(response.data.users)
      }
    })
  }
}
