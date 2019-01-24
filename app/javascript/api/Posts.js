import API from "Services/api";

class Posts {
  constructor(boardId, options = {}) {
    this.boardId = boardId;
    this.postId = options.postId || null;
  }

  getOne() {
    const api = new API(`/admin/${this.boardId}/posts/${this.postId}`)

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

  getMany(params = {}) {
    const api = new API(`/${this.boardId}/posts`, { params });

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

  comment(data) {
    const api = new API(`/${this.boardId}/posts/${this.postId}/comments`, {
      method: "post",
      data
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

  upvote() {
    const api = new API(`/${this.boardId}/posts/${this.postId}/votes`, {
      method: "post"
    });

    return new Promise((resolve, reject) => {
      api.execute()
        .then(response => {
          resolve(response);
        })
        .catch(response => {
          reject(response);
        })
    })
  }

  downvote() {
    const api = new API(`/${this.boardId}/posts/${this.postId}/votes`, {
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
