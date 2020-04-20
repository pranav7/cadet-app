import React, { useState, useEffect } from "react";
import { Form } from "semantic-ui-react";
import Users from "API/Users";

const User = ({ name, email }) => {
  return (
    <div className="item" data-value="20">
      <div className="user">
        <div className="details">
          <span className="name">{name}</span>
          <br />
          <span className="meta soft">{email}</span>
        </div>
      </div>
    </div>
  );
};

const UsersDropdown = ({
  value,
  onChange,
  name,
  hint = null,
  label = "Requester (optional)"
}) => {
  const [isFetchingUsers, setIsFetchingUsers] = useState(false);
  const [users, setUsers] = useState([]);

  useEffect(() => {
    setIsFetchingUsers(true);
    const usersApi = new Users();

    usersApi.get().then(response => {
      setIsFetchingUsers(false);
      const options = response.data.users.map(user => ({
        key: user.id,
        value: user.id,
        text: user.name,
        description: user.description,
        content: <User name={user.name} email={user.email} />
      }));
      setUsers(options);
    });
  }, []);

  return (
    <Form.Field>
      <Form.Select
        fluid
        name={name}
        label={label}
        onChange={onChange}
        search
        value={value}
        options={users}
        placeholder="Select user"
        loading={isFetchingUsers}
      />
      <div className="hint">{hint}</div>
    </Form.Field>
  );
};

export default UsersDropdown;
