import API from 'Services/api';

class Tags {


  search(data) {
    const api = new API(`/admin/tags/search`, {
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
}

export default Tags;