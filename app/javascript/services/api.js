class API {
  constructor(url, options = {}) {
    this.url = url;
    this.method = options.method || "get";
    this.params = options.params || {}
    this.headers = {
      'Content-Type': "application/json",
      'Accept': "application/json",
      'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
    }
  }

  execute() {
    return new Promise((resolve, reject) => {
      axios({
        method: this.method,
        url: this.url,
        headers: this.headers,
        params: this.params
      })
      .then(response => {
        resolve(response);
      })
      .catch(response => {
        reject(response);
      })
    });
  }
}

export default API;
