import API from "Services/api";

class Users {
  get() {
    const usersApi = new API(`/users`, {
      method: "get",
    });

    return new Promise((resolve, reject) => {
      usersApi.execute()
        .then(response => {
          console.log('Users-response', response);
          resolve(response);
        })
        .catch(response => {
          reject(response);
        });
    });
  }
}

export default Users;
