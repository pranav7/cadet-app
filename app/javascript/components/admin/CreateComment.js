import React, { Component } from 'react';
import { connect } from 'react-redux';
import {
  Form,
  TextArea,
  Tab,
  Button
} from 'semantic-ui-react';

import Posts from 'API/Posts';
import { fetchPost } from 'Modules/Posts/Actions';

class CreateComment extends Component {
  constructor(props) {
    super(props);

    this.state = {
      comment: '',
      note: ''
    };

    this.handleNoteChange = this.handleNoteChange.bind(this);
    this.handleCommentChange = this.handleCommentChange.bind(this);
    this.submitComment = this.submitComment.bind(this);
    this.submitNote = this.submitNote.bind(this);
  }

  handleCommentChange(event) {
    this.setState({ comment: event.target.value });
  }

  handleNoteChange(event) {
    this.setState({ note: event.target.value });
  }

  submitComment() {
    const postsApi = new Posts(this.props.boardId, { postId: this.props.postId });
    const data = {
      comment: {
        content_attributes: {
          body: this.state.comment
        }
      }
    }

    postsApi.comment(data)
      .then(response => {
        this.props.dispatch(fetchPost(this.props.boardId, this.props.postId));
        this.setState({ comment: '' });
      })
      .catch(response => {
        console.log("Error Creating Comment", response)
      })
  }

  submitNote() {
    const postsApi = new Posts(this.props.boardId, { postId: this.props.postId });
    const data = {
      comment: {
        private: true,
        content_attributes: {
          body: this.state.note
        }
      }
    }

    postsApi.comment(data)
      .then(response => {
        this.props.dispatch(fetchPost(this.props.boardId, this.props.postId));
        this.setState({ note: '' });
      })
      .catch(response => {
        // TODO: Add Notification Toast
        console.log("Error Creating Comment", response)
      })
  }

  renderComment() {
    return (
      <Tab.Pane>
        <Form onSubmit={this.submitComment}>
          <TextArea
            value={this.state.comment}
            onChange={this.handleCommentChange}
            id="newComment"
            className="text transparent"
            placeholder="Type your reply ..."
            rows="4"
          />
          
          <Button type="submit" size="small">Reply</Button>
          <a className="styling-with-markdown"
            href="https://guides.github.com/features/mastering-markdown/"
            target="_blank" >
            <span className="label">Styling with Markdown is supported</span>
          </a>
        </Form>
      </Tab.Pane>
    )
  }

  renderNote() {
    return (
      <Tab.Pane>
        <Form onSubmit={this.submitNote}>
          <TextArea
            value={this.state.note}
            onChange={this.handleNoteChange}
            id="newNote"
            className="text transparent"
            placeholder="Type your reply ..."
            rows="4" />

          <Button type="submit" size="small">Add Note</Button>
          <a className="styling-with-markdown"
            href="https://guides.github.com/features/mastering-markdown/"
            target="_blank" >
            <span className="label">Styling with Markdown is supported</span>
          </a>
        </Form>
      </Tab.Pane>
    )
  }

  render() {
    const panes = [
      { menuItem: 'Reply', render: () => this.renderComment() },
      { menuItem: 'Note', render: () =>  this.renderNote() }
    ]

    return (
      <Tab panes={panes} />
    )
  }
}

export default connect()(CreateComment);
