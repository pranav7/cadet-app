const headers = {
  'Content-Type': "application/json",
  'Accept': "application/json",
  'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
}

class HTTP {
  static get(url) {
    return new Promise((resolve, reject) => {
      axios({
        method: "GET",
        url: url,
        headers: headers
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

export default HTTP;
