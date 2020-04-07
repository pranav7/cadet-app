import React, { useState, useEffect } from 'react';
import { Form } from "semantic-ui-react";
import Users from "API/Users";

const UsersDropdown = ({ value, onChange, name, hint = null }) => {
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
      }));
      setUsers(options);
    });
  }, []);

  return (
    <Form.Field>
      <Form.Select
        fluid
        name={name}
        label="Add Requester(optional)"
        onChange={onChange}
        search
        value={value}
        options={users}
        placeholder='Select user'
        loading={isFetchingUsers}
      />
      <div className="hint">
        {hint}
      </div>
    </Form.Field>
  );
};

export default UsersDropdown;
