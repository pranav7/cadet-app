import API from "Services/api";

class Board {
  constructor(boardSlug) {
    this.boardSlug = boardSlug;
  }

  get() {
    const boardApi = new API(`/admin/${this.boardSlug}`, {
      method: "get",
    });

    return new Promise((resolve, reject) => {
      boardApi.execute()
        .then(response => {
          resolve(response);
        })
        .catch(response => {
          reject(response);
        });
    });
  }
}

export default Board;
