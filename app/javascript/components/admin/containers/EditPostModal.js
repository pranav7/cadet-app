import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import { Button, Modal, Form, Input, TextArea } from "semantic-ui-react";
import { fetchPosts, fetchPost } from "Modules/Posts/Actions";
import MarkdownStyling from "Common/MarkdownStyling";
import Posts from "API/Posts";

class EditPostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: props.post.title,
      description: props.post.content.raw,
      titleHasError: false,
      modalOpen: false
    };
  }

  componentWillReceiveProps = nextProps => {
    this.setState({
      title: nextProps.post.title,
      description: nextProps.post.content.raw,
      titleHasError: false,
      modalOpen: false
    });
  };

  handleChange = (e, { name, value }) => {
    this.setState({ [name]: value });
  };

  handleOnBlur = () => {
    if (this.state.title === "") {
      return this.setState({ titleHasError: true });
    }
  };

  handleOpen = e => {
    e.preventDefault();
    this.setState({ modalOpen: true });
  };

  handleSubmit = () => {
    if (this.state.title === "") {
      return this.setState({ titleHasError: true });
    } else {
      this.updatePost();
    }
  };

  handleClose = () => {
    this.setState({ modalOpen: false });
  };

  updatePost = () => {
    window.props = this.props;
    const postApi = new Posts(this.props.match.params.boardId, {
      postId: this.props.match.params.postId
    });
    const data = {
      post: {
        title: this.state.title,
        content_attributes: {
          body: this.state.description
        }
      }
    };

    postApi.update(data).then(response => {
      this.props.dispatch(fetchPosts(this.props.match.params.boardId));
      this.props.dispatch(
        fetchPost(
          this.props.match.params.boardId,
          this.props.match.params.postId
        )
      );
      this.setState({
        title: "",
        description: "",
        titleHasError: false,
        modalOpen: false
      });
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
              <i className="pencil icon"></i>
              Edit
            </a>
          </div>
        }
        centered={false}
        open={this.state.modalOpen}
        onClose={this.handleClose}
        size="tiny"
      >
        <Modal.Header>Edit Post</Modal.Header>
        <Modal.Content>
          <Modal.Description>
            <Form onSubmit={this.handleSubmit}>
              <Form.Field>
                <Form.Input
                  value={this.state.title}
                  name="title"
                  placeholder="Title"
                  autoComplete="off"
                  onChange={this.handleChange}
                  onBlur={this.handleOnBlur}
                  error={this.state.titleHasError}
                />
              </Form.Field>
              <Form.Field>
                <Form.TextArea
                  value={this.state.description}
                  name="description"
                  placeholder="Description"
                  rows={13}
                  onChange={this.handleChange}
                />
              </Form.Field>

              <Button primary type="submit">
                Save
              </Button>
              <Button basic onClick={this.handleClose}>
                Close
              </Button>
              <MarkdownStyling />
            </Form>
          </Modal.Description>
        </Modal.Content>
      </Modal>
    );
  }
}

export default withRouter(connect()(EditPostModal));
