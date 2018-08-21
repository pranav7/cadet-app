export default class {
  static get(boardId, options = {}) {
    let url = null;

    if ($.isEmptyObject(options)) {
      url = `/${boardId}/posts`
    } else {
      url = `/${boardId}/posts?${$.param(options)}`
    }

    return new Promise((resolve, reject) => {
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
        resolve(response.data.posts);
      })
      .catch(response => {
        reject(response.status)
      })
    });
  }
}
