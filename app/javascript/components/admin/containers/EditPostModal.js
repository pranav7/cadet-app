import React, { Component } from "react";
import { connect } from "react-redux";
import { withRouter } from "react-router-dom";
import { Button, Modal, Form, Input, TextArea } from "semantic-ui-react";
import { fetchPosts, fetchPost } from "Modules/Posts/Actions";
import MarkdownStyling from "Common/MarkdownStyling";
import Posts from "API/Posts";
import Users from "API/Users";
import EventBus from 'Common/EventBus';
import _ from "underscore";
import UsersDropdown from 'Components/UsersDropdown';

class EditPostModal extends Component {
  constructor(props) {
    super(props);

    this.state = {
      title: props.post.title,
      description: props.post.content.raw,
      modalOpen: false,
      requester: this.props.post.requester ? this.props.post.requester.id : null,
    };
  }

  componentWillReceiveProps = nextProps => {
    this.setState({
      title: nextProps.post.title,
      description: nextProps.post.content.raw,
      requester: nextProps.post.requester.id,
      modalOpen: false
    });
  };

  handleChange = (e, { name, value }) => {
    this.setState({ [name]: value });
  };

  handleOpen = e => {
    e.preventDefault();
    this.setState({ modalOpen: true });
  };

  handleSubmit = () => {
    if(!!this.state.title) {
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

    if (this.state.requester) {
      data.post["user_id"] = this.state.requester;
    }

    postApi.update(data).then(response => {
      if (_.isUndefined(Cookies.get("currentSortOrder"))) {
        this.props.dispatch(fetchPosts({
          boardId:this.props.match.params.boardId
        }));
      } else {
        this.props.dispatch(fetchPosts({
          boardId:this.props.match.params.boardId,
          params: {
            sort_by: Cookies.get("currentSortOrder")
          }
        }));
      }

      this.props.dispatch(
        fetchPost(
          this.props.match.params.boardId,
          this.props.match.params.postId
        )
      );
      EventBus.fire('updated-post', { post_slug: response.data.post.slug });
      this.setState({
        title: "",
        description: "",
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
                  error={!this.state.title}
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
              <UsersDropdown
                onChange={this.handleChange}
                value={this.state.requester}
                name="requester"
                hint="The requester would receive email notifications for this post, only use this option if you have their consent."
              />
              <Button primary type="submit" disabled={!this.state.title || !this.state.description}>
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
