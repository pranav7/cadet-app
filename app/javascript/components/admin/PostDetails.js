import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Container, Icon } from 'semantic-ui-react';

import Posts from 'API/Posts';
import UpvoteButton from 'Components/UpvoteButton';
import CreateComment from 'AdminComponents/CreateComment';
import User from 'Components/User';
import Comment from 'Components/Comment';
import { fetchPost } from 'Modules/Posts/Actions';
import StatusDropdown from 'AdminContainers/StatusDropdown';

class PostDetails extends Component {
  constructor(props) {
    super(props);

    this.state = {
      post: null,
      boardId: this.props.match.params.boardId,
      postId: this.props.match.params.postId
    };

    this.getPost = this.getPost.bind(this);
  }

  componentDidMount() {
    this.getPost();
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.postId != nextProps.match.params.postId) {
      this.setState({
        boardId: nextProps.match.params.boardId,
        postId: nextProps.match.params.postId
      }, () => { this.getPost(); });
    }
  }

  getPost() {
    this.props.fetchPost(this.state.boardId, this.state.postId);
  }

  render() {
    if (this.props.post != null) {
      return (
        <React.Fragment>
          <div className="c-main-pane">
            <div className="top-action-bar">
              <div className="item grow">
                <StatusDropdown
                  boardId={this.state.boardId}
                  postId={this.state.postId}
                />
              </div>

              <div className="item u__pr__x2">
                <a href="" id="edit-post-btn" className="fluid ui tiny button">
                  <i className="pencil icon"></i>
                  Edit
                </a>
              </div>

              <div className="item">
                <a
                  className="fluid ui tiny button"
                  id="delete-post-btn"
                  data-confirm="Are you sure you want to delete this post? Please note that this step is IRREVERSIBLE."
                  rel="nofollow"
                  data-method="delete"
                  href={`/admin/${this.state.boardId}/posts/${this.props.post.slug}/`}
                >
                  <i className="trash alternate icon"></i>
                  Delete
                </a>
              </div>
            </div>

            <div className="post-header">
              <div className="header">
                <h1 className="post-title">{this.props.post.title}</h1>
                <div className="post-header-info">
                  <strong className={`status ${this.props.post.status}`}>
                    #{this.props.post.status}
                  </strong>
                </div>
              </div>
              <div className="votes">
                <UpvoteButton
                  voteCount={this.props.post.votes_count}
                  upvoted={this.props.post.upvoted}
                  boardId={this.state.boardId}
                  postId={this.state.postId}
                />
              </div>
            </div>

            <div className="post-content">
              <Comment
                content={this.props.post.content}
                created_at={this.props.post.created_at}
                id={this.props.post.id}
                commenter={this.props.post.requester}
                isNote={false} />
            </div>

            <div className="create-comment bottom padded">
              <CreateComment
                boardId={this.state.boardId}
                postId={this.state.postId}
              />
            </div>

            <div className="post-activity">
              <div className="activity-header">
                <div className="text">
                  <i className="comments outline icon" />
                  Conversation
                </div>
              </div>

              {this.props.post.comments.map((comment) =>
                <Comment
                  {...comment}
                  isNote={comment.private}
                  key={comment.id} />
              )}
            </div>
          </div>
          <div className="c-right-pane">
            <div className="voters box o__transparent o__no-padding">
              <div className="box-header">
                <div className="header-text">
                  <i className="user outline icon"></i>
                  Users who upvoted
                </div>
              </div>

              {this.props.post.voters.map((voter) => 
                <div className="voter" key={voter.id}>
                  <User name={voter.name}
                    initials={voter.initials}
                    role={voter.role}
                    avatarSize="small" />
                </div>
              )}
            </div>
          </div>
        </React.Fragment>
      );
    } else {
      return(
        <Container className="padded full">
          <Icon loading name='circle notch' size="large" color="grey" />
          <span className="soft">Loading ...</span>
        </Container>
      );
    }
  }
}

const mapStateToProps = (state) => ({
  isFetching: state.isFetching,
  post: state.selectedPost
});

const mapDispatchToProps = (dispatch) => ({
  fetchPost: (boardId, postId) => { dispatch(fetchPost(boardId, postId)); }
});

export default connect(mapStateToProps, mapDispatchToProps)(PostDetails);
