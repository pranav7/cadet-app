import API from "Services/api";

class Comment {
  constructor(boardId, postId, commentId) {
    this.boardId = boardId;
    this.postId = postId;
    this.id = commentId;
  }

  update(data) {
    const commentApi = new API(`/${this.boardId}/posts/${this.postId}/comments/${this.id}`, {
      method: "put",
      data,
    });

    return new Promise((resolve, reject) => {
      commentApi.execute()
        .then(response => {
          resolve(response);
        })
        .catch(response => {
          reject(response);
        });
    });
  }

  delete() {
    const commentApi = new API(`/${this.boardId}/posts/${this.postId}/comments/${this.id}`, {
      method: "delete",
    });

    return new Promise((resolve, reject) => {
      commentApi.execute()
        .then(response => {
          resolve(response);
        })
        .catch(response => {
          reject(response);
        });
    });
  }
}

export default Comment;
