import React from "react";
import { Label } from "semantic-ui-react";

const Account = ({ id, name, votes, mrr }) => {
  return (
    <div className="u__p__x2" style={{ display: "flex" }}>
      <span className="u__pr__x2">{name}</span>
      <Label.Group circular>
        <Label size="mini">
          <i className="caret up icon"></i>
          {votes}
        </Label>
        <Label size="mini">${mrr}/mo</Label>
      </Label.Group>
    </div>
  );
};

export default Account;
