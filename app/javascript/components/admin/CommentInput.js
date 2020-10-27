import React, { Component } from "react";
import { connect } from "react-redux";
import { Grid, Form, TextArea, Tab, Button, Popup } from "semantic-ui-react";
import { osName } from "react-device-detect";

import Posts from "API/Posts";
import { fetchPost } from "Modules/Posts/Actions";
import MarkdownStyling from "Common/MarkdownStyling";
import { MentionsInput, Mention } from "react-mentions";
import Users from "API/Users";
import {
  CommentTextAreaWithMentionStyles,
  MentionStyles
} from "Common/MentionsStyling";
import MentionSuggestion from "Components/MentionSuggestion";

class CreateComment extends Component {
  constructor(props) {
    super(props);

    this.state = {
      comment: "",
      note: "",
      users: []
    };

    this.handleNoteChange = this.handleNoteChange.bind(this);
    this.handleCommentChange = this.handleCommentChange.bind(this);
    this.submitComment = this.submitComment.bind(this);
    this.submitNote = this.submitNote.bind(this);
    this.handleCmdEnter = this.handleCmdEnter.bind(this);
  }

  componentDidMount() {
    const usersApi = new Users();

    usersApi.get().then(response => {
      this.setState({
        users: response.data.users.map(user => ({
          id: user.username,
          display: user.name
        }))
      });
    });
    if (this.props.value && this.props.value.comment) {
      this.setState({
        comment: this.props.value.comment
      });
    }

    if (this.props.value && this.props.value.note) {
      this.setState({
        note: this.props.value.note
      });
    }
  }

  handleCmdEnter(e, resolve) {
    if (e.keyCode == 13 && (e.metaKey || e.ctrlKey)) {
      resolve();
    }
  }

  handleCommentChange(event) {
    this.setState({ comment: event.target.value });
  }

  handleNoteChange(event) {
    this.setState({ note: event.target.value });
  }

  submitComment() {
    if (this.props.value) {
      // https://github.com/signavio/react-mentions/issues/78
      this.props.onSubmit(this.state.comment.replace(/@@/g, "@"));
      return;
    }

    const postsApi = new Posts(this.props.boardId, {
      postId: this.props.postId
    });
    const data = {
      comment: {
        content_attributes: {
          body: this.state.comment.replace(/@@/g, "@")
        }
      }
    };

    postsApi
      .comment(data)
      .then(response => {
        this.props.dispatch(fetchPost(this.props.boardId, this.props.postId));
        this.setState({ comment: "" });
      })
      .catch(response => {
        // TODO: Add Notification Toast
        console.log("Error Creating Comment", response);
      });
  }

  submitNote() {
    if (this.props.value) {
      // https://github.com/signavio/react-mentions/issues/78
      this.props.onSubmit(this.state.note.replace(/@@/g, "@"));
      return;
    }

    const postsApi = new Posts(this.props.boardId, {
      postId: this.props.postId
    });
    const data = {
      comment: {
        private: true,
        content_attributes: {
          body: this.state.note.replace(/@@/g, "@")
        }
      }
    };

    postsApi
      .comment(data)
      .then(response => {
        this.props.dispatch(fetchPost(this.props.boardId, this.props.postId));
        this.setState({ note: "" });
      })
      .catch(response => {
        // TODO: Add Notification Toast
        console.log("Error Creating Comment", response);
      });
  }

  renderComment() {
    return (
      <Tab.Pane attached={false}>
        <Form onSubmit={this.submitComment}>
          <MentionsInput
            value={this.state.comment}
            onChange={this.handleCommentChange}
            onKeyDown={event => {
              this.handleCmdEnter(event, this.submitComment);
            }}
            id="newComment"
            className="text transparent"
            placeholder="Type your reply ..."
            rows="4"
            style={CommentTextAreaWithMentionStyles}
          >
            <Mention
              trigger="@"
              data={this.state.users}
              style={MentionStyles}
              displayTransform={username => `@${username}`}
              appendSpaceOnAdd
              // https://github.com/signavio/react-mentions/issues/78
              regex={/@@([\w_-]+)/}
              markup="@@__id__"
              renderSuggestion={(
                suggestion,
                query,
                highlightedDisplay,
                index,
                focused
              ) => (
                <MentionSuggestion
                  suggestion={suggestion}
                  query={query}
                  highlightedDisplay={highlightedDisplay}
                  index={index}
                  focused={focused}
                />
              )}
            />
          </MentionsInput>
          <Grid verticalAlign="middle">
            <Grid.Row>
              <Grid.Column width={6}>
                <Popup
                  content={this.cmdOrCtrl()}
                  size="mini"
                  position="bottom center"
                  trigger={
                    <Button
                      primary
                      type="submit"
                      size="tiny"
                      disabled={this.state.comment == ""}
                    >
                      Reply
                    </Button>
                  }
                  inverted
                />
              </Grid.Column>

              <Grid.Column textAlign="right" width={10}>
                <MarkdownStyling />
              </Grid.Column>
            </Grid.Row>
          </Grid>
        </Form>
      </Tab.Pane>
    );
  }

  renderNote() {
    // TODO: Extract TextArea into a sub-component
    // https://stackoverflow.com/a/29810951
    return (
      <Tab.Pane id="note-container" attached={false}>
        <Form onSubmit={this.submitNote}>
          <MentionsInput
            value={this.state.note}
            onChange={this.handleNoteChange}
            onKeyDown={event => {
              this.handleCmdEnter(event, this.submitNote);
            }}
            id="newNote"
            className="text transparent"
            placeholder="Notes are only visible to Admins. Type your note ..."
            rows="4"
            style={CommentTextAreaWithMentionStyles}
          >
            <Mention
              trigger="@"
              data={this.state.users}
              style={MentionStyles}
              displayTransform={username => `@${username}`}
              // https://github.com/signavio/react-mentions/issues/78
              appendSpaceOnAdd
              regex={/@@([\w_-]+)/}
              markup="@@__id__"
              renderSuggestion={(
                suggestion,
                query,
                highlightedDisplay,
                index,
                focused
              ) => (
                <MentionSuggestion
                  suggestion={suggestion}
                  query={query}
                  highlightedDisplay={highlightedDisplay}
                  index={index}
                  focused={focused}
                />
              )}
            />
          </MentionsInput>

          <Grid verticalAlign="middle">
            <Grid.Row>
              <Grid.Column width={6}>
                <Popup
                  content={this.cmdOrCtrl()}
                  size="mini"
                  position="bottom center"
                  trigger={
                    <Button
                      primary
                      type="submit"
                      size="tiny"
                      disabled={this.state.note == ""}
                    >
                      Add Note
                    </Button>
                  }
                  inverted
                />
              </Grid.Column>

              <Grid.Column textAlign="right" width={10}>
                <MarkdownStyling />
              </Grid.Column>
            </Grid.Row>
          </Grid>
        </Form>
      </Tab.Pane>
    );
  }

  cmdOrCtrl() {
    if (osName == "Mac OS") {
      return "⌘+Enter";
    } else {
      return "Ctrl+Enter";
    }
  }

  render() {
    if (this.props.renderCommentOnly) {
      return this.renderComment();
    }

    if (this.props.renderNoteOnly) {
      return this.renderNote();
    }

    const panes = [
      { menuItem: "Reply", render: () => this.renderComment() },
      { menuItem: "Note", render: () => this.renderNote() }
    ];

    return <Tab menu={{ secondary: true, pointing: true }} panes={panes} />;
  }
}

export default connect()(CreateComment);
