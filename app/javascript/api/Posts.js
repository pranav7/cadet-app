import API from 'Services/api';

class Posts {
  constructor(boardId, options = {}) {
    this.boardId = boardId;
    this.postId = options.postId || null;
  }

  getOne() {
    const api = new API(`/admin/${this.boardId}/posts/${this.postId}`);

    return new Promise((resolve, reject) => {
      api
        .execute()
        .then((response) => {
          resolve({
            post: response.data,
            headers: response.headers,
          });
        })
        .catch((response) => {
          reject(response.status);
        });
    });
  }

  getMany(params = {}) {
    console.log('Getting Posts');
    const api = new API(`/${this.boardId}/posts`, { params });

    return new Promise((resolve, reject) => {
      api
        .execute()
        .then((response) => {
          resolve({
            posts: response.data.posts,
            headers: response.headers,
          });
        })
        .catch((response) => {
          reject(response.status);
        });
    });
  }

  update(data) {
    const api = new API(`/admin/${this.boardId}/posts/${this.postId}`, {
      method: 'put',
      data,
    });

    return new Promise((resolve, reject) => {
      api
        .execute()
        .then((response) => {
          resolve(response);
        })
        .catch((response) => {
          reject(response.status);
        });
    });
  }

  create(data) {
    const api = new API(`/admin/${this.boardId}/posts/`, {
      method: 'post',
      data,
    });

    return new Promise((resolve, reject) => {
      api
        .execute()
        .then((response) => {
          resolve(response);
        })
        .catch((response) => {
          reject(response.status);
        });
    });
  }

  comment(data) {
    const api = new API(`/${this.boardId}/posts/${this.postId}/comments`, {
      method: 'post',
      data,
    });

    return new Promise((resolve, reject) => {
      api
        .execute()
        .then((response) => {
          resolve(response);
        })
        .catch((response) => {
          reject(response.status);
        });
    });
  }

  upvote(data = undefined) {
    const api = new API(`/${this.boardId}/posts/${this.postId}/votes`, {
      method: 'post',
      data,
    });

    return new Promise((resolve, reject) => {
      api
        .execute()
        .then((response) => {
          resolve(response);
        })
        .catch((response) => {
          reject(response);
        });
    });
  }

  downvote(data = undefined) {
    const api = new API(`/${this.boardId}/posts/${this.postId}/votes`, {
      method: 'delete',
      data,
    });

    return new Promise((resolve, reject) => {
      api
        .execute()
        .then((response) => {
          resolve(response);
        })
        .catch((response) => {
          reject(response.status);
        });
    });
  }
}

export default Posts;
