import API from "Services/api";

class Users {
  get() {
    const usersApi = new API(`/admin/users`, {
      method: "get",
    });

    return new Promise((resolve, reject) => {
      usersApi.execute()
        .then(response => {
          resolve(response);
        })
        .catch(response => {
          reject(response);
        });
    });
  }
}

export default Users;
