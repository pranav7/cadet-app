import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import { Button, Modal, Form } from "semantic-ui-react";
import Users from "API/Users";
import Posts from "API/Posts";
import UsersDropdown from 'Components/UsersDropdown';

class EditPostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      voter: null,
      modalOpen: false,
    };
  }

  handleChange = (e, { name, value }) => {
    this.setState({ [name]: value });
  };

  handleOpen = e => {
    e.preventDefault();
    this.setState({ modalOpen: true });
  };

  handleSubmit = () => {
    this.addVoter();
  };

  handleClose = () => {
    this.setState({ modalOpen: false, voter: null });
  };

  addVoter = () => {
    const postApi = new Posts(this.props.match.params.boardId, {
      postId: this.props.match.params.postId
    });
    const data = {
      user_id: this.state.voter
    };

    postApi.upvote(data).then(response => {
      this.setState({
        modalOpen: false,
        voter: null
      }, this.props.onChange);
    });
  };

  render() {
    return (
      <Modal
        id="vote-on-behalf-modal"
        trigger={
          <div className="item u__pr__x2">
            <a
              href=""
              id="edit-post-btn"
              className="fluid ui tiny button"
              onClick={this.handleOpen}
            >
              <i className="plus icon"></i>
              Add Voter
            </a>
          </div>
        }
        centered={false}
        open={this.state.modalOpen}
        onClose={this.handleClose}
        size="tiny"
      >
        <Modal.Header>Add Voter</Modal.Header>
        <Modal.Content>
          <Modal.Description>
            <Form onSubmit={this.handleSubmit}>
              <Form.Field>
                <UsersDropdown
                  onChange={this.handleChange}
                  value={this.state.voter}
                  name="voter"
                />
              </Form.Field>
              <Button size="tiny" type="submit">
                <i className="plus icon"></i>
                Add
              </Button>
            </Form>
          </Modal.Description>
        </Modal.Content>
        <Modal.Actions style={{ textAlign: 'left' }}>
          Please note that these users <strong>will not</strong> receive emails when you change the status of the post.
        </Modal.Actions>
      </Modal>
    );
  }
}

export default withRouter(connect()(EditPostModal));
