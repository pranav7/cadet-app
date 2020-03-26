import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import { Button, Modal, Form } from "semantic-ui-react";
import Users from "API/Users";
import Posts from "API/Posts";

const User = ({ name, email }) => {

  return (
    <div class="item" data-value="20">
      <div class="user">
        <div class="details">
          <span class="name">{name}</span>
          <br />
          <span class="meta soft">{email}</span>
        </div>
      </div>
    </div>
  )
};

class EditPostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedUser: null,
      modalOpen: false,
      users: [],
      loading: false,
    };
  }

  componentDidMount(){
    this.setState({
      loading: true
    });
    const usersApi = new Users();

    usersApi.get().then(response => {
      this.setState({
        users: response.data.users.map(user => ({
          key: user.id,
          value: user.id,
          text: user.name,
          content: <User name={user.name} email={user.email} />,
          description: user.description,
        }
        )),
        loading: false,
      });
    });
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
    this.setState({ modalOpen: false });
  };

  addVoter = () => {
    const postApi = new Posts(this.props.match.params.boardId, {
      postId: this.props.match.params.postId
    });
    const data = {
      user_id: this.state.selectedUser
    };

    postApi.upvote(data).then(response => {
      this.setState({
        modalOpen: false
      }, this.props.onChange);
    });
  };

  render() {
    return (
      <Modal
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
                <Form.Select
                  fluid
                  name="selectedUser"
                  onChange={this.handleChange}
                  search
                  options={this.state.users}
                  placeholder='Select user'
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
