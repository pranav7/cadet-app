import React from "react";
import { Modal } from "semantic-ui-react";
import User from 'Components/User';

const UpvotedUsersListModal = ({ voters }) => {
  const [isModalOpen, setIsModalOpen] = React.useState(false);

  const handleOpen = (e) => {
    e.preventDefault();
    setIsModalOpen(true)
  };

  const handleClose = () => setIsModalOpen(false);

  return (
    <Modal
      trigger={
        <div className="item u__pr__x2">
          <a
            href=""
            className="c underlined link"
            onClick={handleOpen}
          >
            and {voters.length - 7} more...
          </a>
        </div>
      }
      centered={false}
      open={isModalOpen}
      onClose={handleClose}
      size="tiny"
    >
        <Modal.Header>Upvoted Users</Modal.Header>
        <Modal.Content>
          {voters.map((voter) => 
            <div className="voter" key={voter.id}>
              <User name={voter.name}
                initials={voter.initials}
                role={voter.role}
                jobTitle={voter.job_title}
                avatarSize="small" />
            </div>
          )}
        </Modal.Content>
      </Modal>
  );
}

export default UpvotedUsersListModal;
