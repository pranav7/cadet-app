import React, { useState, useEffect } from "react";
import { withRouter } from "react-router-dom";
import User from "Components/User";
import Posts from "API/Posts";
import UpvotedUsersListModal from "Components/admin/containers/UpvotedUsersListModal";

const UpvotedUsersList = ({
  voters: originalVoters,
  onDelete,
  compact = false,
  match
}) => {
  const [voters, setVoters] = useState([]);

  useEffect(() => {
    setVoters(originalVoters);
  }, [originalVoters]);

  const downvote = downvoterId => {
    const postApi = new Posts(match.params.boardId, {
      postId: match.params.postId
    });
    const data = {
      user_id: downvoterId
    };

    postApi.downvote(data).then(response => {
      setVoters(voters.filter(voter => voter.id != downvoterId));
      onDelete();
    });
  };

  return (
    <React.Fragment>
      {voters.slice(0, compact ? 7 : voters.length).map(voter => (
        <div key={voter.id} style={{ display: 'flex', alignItems: 'center'}}>
          <User
            name={voter.name}
            initials={voter.initials}
            role={voter.role}
            jobTitle={voter.job_title}
            companyName={voter.company_name}
            avatarSize="small"
          />
          {voter.deletable && (
            <i
              className="close icon pointer soft u__pl__x2"
              onClick={() => downvote(voter.id)}
            />
          )}
        </div>
      ))}
      {compact && voters.length > 7 && (
        <UpvotedUsersListModal voters={voters} />
      )}
    </React.Fragment>
  );
};

export default withRouter(UpvotedUsersList);
