class API {
  constructor(url, options = {}) {
    this.url = url;
    this.method = options.method || "get";
    this.params = options.params || {};
    this.data = options.data || {}
    this.headers = {
      'Content-Type': "application/json",
      'Accept': "application/json",
      'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
    }
  }

  execute() {
    return new Promise((resolve, reject) => {
      console.log(this);
      axios({
        method: this.method,
        url: this.url,
        headers: this.headers,
        params: this.params,
        data: this.data
      })
      .then(response => {
        resolve(response);
      })
      .catch(error => {
        reject(error.response);
      })
    });
  }
}

export default API;
