import React, { Component } from 'react';
import { connect } from 'react-redux';
import {
  Grid,
  Form,
  TextArea,
  Tab,
  Button
} from 'semantic-ui-react';
import { osName } from 'react-device-detect';
import { FiCommand, FiCornerDownLeft, FiPlus } from 'react-icons/fi';
import { GoMarkdown } from 'react-icons/go';

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
    this.handleCmdEnter = this.handleCmdEnter.bind(this);
  }

  handleCmdEnter(e, resolve) {
    if(e.keyCode == 13 && (e.metaKey || e.ctrlKey)) {
      resolve()
    }
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
        // TODO: Add Notification Toast
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
      <Tab.Pane attached={false} >
        <Form onSubmit={this.submitComment} >
          <TextArea
            value={this.state.comment}
            onChange={this.handleCommentChange}
            onKeyDown={(event) => { this.handleCmdEnter(event, this.submitComment) }}
            id="newComment"
            className="text transparent"
            placeholder='Type your reply ...'
            rows="4"
          />

          <Grid verticalAlign='middle'>
            <Grid.Row>
              <Grid.Column width={6}>
                <Button type="submit" size="small" disabled={this.state.comment == ''}>Reply</Button>
                { osName == "Mac OS" ? this.renderHitCommandEnter() : "" }
              </Grid.Column>

              <Grid.Column textAlign="right" width={10}>
                {this.renderWithMarkdown()}
              </Grid.Column>
            </Grid.Row>
          </Grid>  
        </Form>
      </Tab.Pane>
    )
  }

  renderNote() {
    // TODO: Extract TextArea into a sub-component
    // https://stackoverflow.com/a/29810951
    return (
      <Tab.Pane id="note-container" attached={false} >
        <Form onSubmit={this.submitNote}>
          <TextArea
            value={this.state.note}
            onChange={this.handleNoteChange}
            onKeyDown={(event) => { this.handleCmdEnter(event, this.submitNote) }}
            id="newNote"
            className="text transparent"
            placeholder='Notes are only visible to Admins. Type your note ...'
            rows="4" />

          <Grid verticalAlign='middle'>
            <Grid.Row>
              <Grid.Column width={6}>
                <Button type="submit" size="small" disabled={this.state.note == ''}>Add Note</Button>
                { osName == "Mac OS" ? this.renderHitCommandEnter() : "" }
              </Grid.Column>

              <Grid.Column textAlign="right" width={10}>
                {this.renderWithMarkdown()}
              </Grid.Column>
            </Grid.Row>
          </Grid>  
        </Form>
      </Tab.Pane>
    )
  }

  renderHitCommandEnter() {
    return (
      <div className="create-comment-keyboard-shortcut">
        <kbd className="keyboard-button">
          <FiCommand />
        </kbd>
        <FiPlus className="soft" />
        <kbd className="keyboard-button">
          <FiCornerDownLeft />
        </kbd>
      </div>
    )
  }

  renderWithMarkdown() {
    return (
      <a className="styling-with-markdown"
        href="https://guides.github.com/features/mastering-markdown/"
        target="_blank" >
        <GoMarkdown size="1.25em" />
        <span className="label">Markdown is supported</span>
      </a>
    )
  }

  render() {
    const panes = [
      { menuItem: 'Reply', render: () => this.renderComment() },
      { menuItem: 'Note', render: () =>  this.renderNote() }
    ]

    return (
      <Tab menu={{ secondary: true, pointing: true }} panes={panes} />
    )
  }
}

export default connect()(CreateComment);
