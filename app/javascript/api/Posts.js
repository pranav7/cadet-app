import API from "Services/api";

class Posts {
  constructor(boardId, options = {}) {
    this.boardId = boardId;
    this.postId = options.postId || null;
  }

  static get(boardId, postId) {
    let api = new API(`/${boardId}/posts/${postId}`)

    return new Promise((resolve, reject) => {
      api.execute()
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

  static getAll(boardId, params = {}) {
    let api = new API(`/${boardId}/posts`, { params: params });

    return new Promise((resolve, reject) => {
      api.execute()
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

  upvote() {
    let api = new API(`/${this.boardId}/posts/${this.postId}/votes`, {
      method: "post"
    });

    return new Promise((resolve, reject) => {
      api.execute()
        .then(response => {
          resolve(response);
        })
        .catch(response => {
          reject(response.status);
        })
    })
  }

  downvote() {
    let api = new API(`/${this.boardId}/posts/${this.postId}/votes`, {
      method: "delete"
    })

    return new Promise((resolve, reject) => {
      api.execute()
        .then(response => {
          resolve(response);
        })
        .catch(response => {
          reject(response.status);
        })
    })
  }
}

export default Posts;
