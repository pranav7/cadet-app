import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Container, Icon } from 'semantic-ui-react';

import UpvoteButton from 'Components/UpvoteButton';
import CommentInput from 'AdminComponents/CommentInput';
import Account from 'Components/Account';
import Comment from 'Components/Comment';
import { fetchPost } from 'Modules/Posts/Actions';
import StatusDropdown from 'AdminContainers/StatusDropdown';
import EditPostModal from 'AdminContainers/EditPostModal';
import AddVoterModal from 'AdminContainers/AddVoterModal';
import UpvotedUsersList from './containers/UpvotedUsersList';

class PostDetails extends Component {
  constructor(props) {
    super(props);

    this.state = {
      post: null,
      boardId: this.props.match.params.boardId,
      postId: this.props.match.params.postId,
    };

    this.getPost = this.getPost.bind(this);
  }

  componentDidMount() {
    this.getPost();
  }

  componentWillReceiveProps(nextProps) {
    if (this.state.postId != nextProps.match.params.postId) {
      this.setState(
        {
          boardId: nextProps.match.params.boardId,
          postId: nextProps.match.params.postId,
        },
        () => {
          this.getPost();
        },
      );
    }
  }

  onPostChange = () => {
    this.getPost();
  };

  getPost() {
    this.props.fetchPost(this.state.boardId, this.state.postId);
  }

  render() {
    if (!this.props.post) {
      return (
        <Container className="padded full">
          <Icon loading name="circle notch" size="large" color="grey" />
          <span className="soft">Loading ...</span>
        </Container>
      );
    } else {
      return (
        <React.Fragment>
          <div className="c-main-pane">
            <div className="top-action-bar">
              <div className="item grow">
                <button onClick={testMethodDoesNotExist}>Break the world</button>;
                <StatusDropdown boardId={this.state.boardId} postId={this.state.postId} />
              </div>

              <EditPostModal post={this.props.post} />

              <div className="item u__pr__x2">
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

              <AddVoterModal post={this.props.post} onChange={this.onPostChange} />
            </div>

            <div className="post-header">
              <div className="header">
                <h1 className="post-title">{this.props.post.title}</h1>
                <div className="post-header-info">
                  <strong className={`status o__small ${this.props.post.status}`}>
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
                  onChange={this.onPostChange}
                />
              </div>
            </div>

            <div className="post-content">
              <Comment
                isPost={true}
                content={this.props.post.content}
                created_at={this.props.post.created_at}
                id={this.props.post.id}
                commenter={this.props.post.requester}
                isNote={false}
                boardId={this.state.boardId}
                postId={this.state.postId}
              />
            </div>

            <div className="create-comment bottom padded">
              <CommentInput boardId={this.state.boardId} postId={this.state.postId} />
            </div>

            <div className="post-activity">
              <div className="activity-header">
                <div className="text">
                  <i className="comments outline icon" />
                  Conversation
                </div>
              </div>

              {this.props.post.comments.map((comment) => (
                <Comment
                  {...comment}
                  isEditable={comment.commenter.id === this.props.currentUser.id}
                  isNote={comment.private}
                  key={comment.id}
                  boardId={this.state.boardId}
                  postId={this.state.postId}
                  onChange={() => this.getPost()}
                />
              ))}
            </div>
          </div>
          <div className="c-right-pane">
            <div className="voters box">
              <div className="box-header">
                <div className="header-text">
                  <i className="user outline icon"></i>
                  Users who upvoted
                </div>
              </div>

              <UpvotedUsersList
                voters={this.props.post.voters}
                compact
                onDelete={this.onPostChange}
              />
            </div>

            {this.props.post.accounts.length > 0 && (
              <div className="voters box">
                <div className="box-header">
                  <div className="header-text">
                    <i className="suitcase icon"></i>
                    Accounts
                  </div>
                </div>

                {this.props.post.accounts.map((account) => (
                  <Account key={account.id} {...account} />
                ))}
              </div>
            )}
          </div>
        </React.Fragment>
      );
    }
  }
}

const mapStateToProps = (state) => ({
  isFetchingPost: state.isFetchingPost,
  post: state.selectedPost,
});

const mapDispatchToProps = (dispatch) => ({
  fetchPost: (boardId, postId) => {
    dispatch(fetchPost(boardId, postId));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PostDetails);
