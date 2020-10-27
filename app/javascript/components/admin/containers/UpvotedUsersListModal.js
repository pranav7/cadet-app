import React from "react";
import { Modal } from "semantic-ui-react";
import UpvotedUsersList from "./UpvotedUsersList";

const UpvotedUsersListModal = ({ voters, onDelete }) => {

  const [isModalOpen, setIsModalOpen] = React.useState(false);

  const handleOpen = e => {
    e.preventDefault();
    setIsModalOpen(true);
  };

  const handleClose = () => setIsModalOpen(false);

  return (
    <Modal
      trigger={
        <div className="item u__pr__x2">
          <a href="" className="c underlined link" onClick={handleOpen}>
            and {voters.length - 7} more...
          </a>
        </div>
      }
      centered={false}
      open={isModalOpen}
      onClose={handleClose}
      size="mini"
    >
      <Modal.Header>Users who upvoted</Modal.Header>
      <Modal.Content>
        <UpvotedUsersList voters={voters} onDelete={onDelete} />
      </Modal.Content>
    </Modal>
  );
};

export default UpvotedUsersListModal;
