import HTTP from "../services/http";

export default class {
  static get(boardId, postId) {
    let url = `/${boardId}/posts/${postId}`

    return new Promise((resolve, reject) => {
      HTTP.get(url)
        .then(response => {
          resolve({
            post: response.data,
            headers: response.headers
          });
        })
        .catch(response => {
          reject(response.status);
        });
    });
  }

  static getAll(boardId, options = {}) {
    let url = null;

    if (_.isEmpty(options)) {
      url = `/${boardId}/posts`
    } else {
      url = `/${boardId}/posts?${$.param(options)}`
    }

    return new Promise((resolve, reject) => {
      HTTP.get(url)
        .then(response => {
          resolve({
            posts: response.data.posts,
            headers: response.headers
          });
        })
        .catch(response => {
          reject(response.status)
        })
    });
  }
}
