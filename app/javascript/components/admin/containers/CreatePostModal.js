import React, { Component } from 'react';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Button, Modal, Form, Input, TextArea } from 'semantic-ui-react';

import Posts from 'API/Posts';
import MarkdownStyling from 'Common/MarkdownStyling';

import { fetchPosts } from 'Modules/Posts/Actions';
import UsersDropdown from 'Components/UsersDropdown';

class CreatePostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: '',
      description: '',
      requester: null,
      modalOpen: false,
      hasChangedTitle: false,
    };
  }

  handleChange = (e, { name, value }) => {
    this.setState({ [name]: value, hasChangedTitle: true });
  };

  handleSubmit = () => {
    if (!!this.state.title) {
      this.createPost();
    }
  };

  createPost = () => {
    const postsApi = new Posts(this.props.boardId);
    const data = {
      post: {
        title: this.state.title,
        content_attributes: {
          body: this.state.description,
        },
      },
    };

    if (this.state.requester) {
      data.post['user_id'] = this.state.requester;
    }

    postsApi
      .create(data)
      .then((response) => {
        this.setState({
          title: '',
          description: '',
          modalOpen: false,
          requester: null,
        });
        this.props.dispatch(
          fetchPosts({
            boardId: this.props.boardId,
          }),
        );
        this.props.history.push(`/admin/${this.props.boardId}/posts/${response.data.post.slug}`);
        this.props.onCreatePost(response.data.post.slug);
      })
      .catch((response) => {
        // TODO: Add Notification Toast
        console.log('Error Creating Post', response);
      });
  };

  handleOpen = (e) => {
    e.preventDefault();
    this.setState({ modalOpen: true });
  };

  handleClose = () => {
    this.setState({
      title: '',
      description: '',
      modalOpen: false,
      requester: null,
    });
  };

  render() {
    return (
      <Modal
        trigger={
          <a id="create-post-btn" href="#" onClick={this.handleOpen}>
            <i className="add square primary big icon button"></i>
          </a>
        }
        centered={false}
        open={this.state.modalOpen}
        onClose={this.handleClose}
        size="tiny"
      >
        <Modal.Header>Create a Post</Modal.Header>
        <Modal.Content>
          <Modal.Description>
            <Form onSubmit={this.handleSubmit}>
              <Form.Field>
                <Form.Input
                  name="title"
                  placeholder="Title"
                  autoComplete="off"
                  onChange={this.handleChange}
                  error={!this.state.title && this.state.hasChangedTitle}
                />
              </Form.Field>
              <Form.Field>
                <Form.TextArea
                  name="description"
                  placeholder="Description"
                  rows={13}
                  onChange={this.handleChange}
                />
              </Form.Field>
              <UsersDropdown
                onChange={this.handleChange}
                value={this.state.requester}
                name="requester"
                hint="The requester would receive email notifications for this post, only use this option if you have their consent."
              />
              <div className="flex flex-row items-center">
                <Button
                  primary
                  type="submit"
                  disabled={!this.state.title || !this.state.description}
                >
                  Save
                </Button>
                <Button basic onClick={this.handleClose}>
                  Close
                </Button>
                <MarkdownStyling />
              </div>
            </Form>
          </Modal.Description>
        </Modal.Content>
      </Modal>
    );
  }
}

export default withRouter(connect()(CreatePostModal));
