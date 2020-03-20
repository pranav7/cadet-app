import React from "react";
import { Label } from 'semantic-ui-react'

const Account = ({ id, name, votes, mrr }) => {
  return (
    <div className="u__p__x2" style={{ display: 'flex' }}>
      <span class="u__pr__x2">{name}</span>
      <Label.Group circular>
        <Label>
          <i className="caret up icon"></i>
          {votes}
        </Label>
        <Label as='a'>${mrr}/mo</Label>
      </Label.Group>
    </div>
  );
};

export default Account;
