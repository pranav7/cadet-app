import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Button, Modal, Form, Input, TextArea } from 'semantic-ui-react';

import Posts from 'API/Posts';
import MarkdownStyling from 'Common/MarkdownStyling';

import { fetchPosts } from 'Modules/Posts/Actions';

class CreatePostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: "",
      description: "",
      titleHasError: false,
      modalOpen: false
    };

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleOpen = this.handleOpen.bind(this);
    this.handleClose = this.handleClose.bind(this);
    this.createPost = this.createPost.bind(this);
  }

  handleChange(e, { name, value }) {
    this.setState({ [name]: value });
  }

  handleSubmit() {
    if (this.state.title === '') {
      return this.setState({ titleHasError: true });
    } else {
      console.log("Submitted", this.state.title, this.state.description);
      this.createPost();
      this.setState({ titleHasError: false });
    }
  }

  createPost() {
    const postsApi = new Posts(this.props.boardId);
    const data = {
      post: {
        title: this.state.title,
        content_attributes: {
          body: this.state.description
        }
      }
    };

    postsApi.create(data)
      .then(response => {
        console.log('Successfully Created Post!');
        this.props.dispatch(fetchPosts(this.props.boardId));
        this.setState({ modalOpen: false });
      })
      .catch(response => {
        // TODO: Add Notification Toast
        console.log("Error Creating Comment", response);
      });
  }

  handleOpen(e) {
    e.preventDefault();
    this.setState({ modalOpen: true });
  }
  
  handleClose() {
    this.setState({ modalOpen: false });
  }

  render() {
    return (
      <Modal
        trigger={
          <a
            id="create-post-btn"
            href="#"
            onClick={this.handleOpen}
          >
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
                  placeholder='Title'
                  autoComplete='off'
                  onChange={this.handleChange}
                  error={this.state.titleHasError}
                />
              </Form.Field>
              <Form.Field>
                <Form.TextArea
                  name="description"
                  placeholder='Description'
                  rows={13}
                  onChange={this.handleChange}
                />
              </Form.Field>

              <Button primary type='submit'>Create</Button>
              <Button basic onClick={this.handleClose}>Close</Button>
              <MarkdownStyling />
            </Form>
          </Modal.Description>
        </Modal.Content>
      </Modal>
    );
  }
}

export default connect()(CreatePostModal);
