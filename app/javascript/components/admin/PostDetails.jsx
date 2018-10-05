import React, { Component } from 'react';
import Posts from '../../wrappers/Posts';
import UpvoteButton from '../UpvoteButton';
import CreateComment from './CreateComment';
import User from '../User';
import Comment from '../Comment';

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
    this.setState({
      boardId: nextProps.match.params.boardId,
      postId: nextProps.match.params.postId
    }, () => { this.getPost(); });
  }

  getPost() {
    Posts.get(this.state.boardId, this.state.postId)
      .then((response) => {
        this.setState({
          post: response.post
        })
      })
  }

  render() {
    if(this.state.post != null) {
      return (
        <React.Fragment>
          <div className="c-main-pane">
            <div className="top-action-bar">
              <div className="item">
                <a href="" id="edit-post-btn">
                  <i className="edit outline large icon"></i>
                </a>
              </div>
              <div className="item">
                <a href="" id="delete-post-btn">
                  <i className="trash alternate outline large icon"></i>
                </a>
              </div>
            </div>

            <div className="post-header">
              <div className="header">
                <h1 className="post-title">{this.state.post.title}</h1>
                <div className="post-header-info">
                  <strong className={`status ${this.state.post.status}`}>
                    #{this.state.post.status}
                  </strong>
                </div>
              </div>
              <div className="votes">
                <UpvoteButton
                  voteCount={this.state.post.votes_count}
                  upvoted={this.state.post.upvoted}
                  boardId={this.state.boardId}
                  postId={this.state.postId}
                />
              </div>
            </div>

            <div className="post-content vertical padded">
              <Comment
                content={this.state.post.content}
                created_at={this.state.post.created_at}
                id={this.state.post.id}
                commenter={this.state.post.requester}
                isNote={false} />
            </div>

            <div className="create-comment bottom padded">
              <CreateComment />
            </div>

            <div className="post-activity">
              <div className="activity-header">
                <div className="text">
                  <i className="comments outline icon" />
                  Conversation
                </div>
              </div>

              {this.state.post.comments.map((comment) =>
                <Comment
                  {...comment}
                  isNote={comment.private}
                  key={comment.id} />
              )}
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
              {this.state.post.voters.map((voter) => 
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
      )
    } else {
      return(<div>Loading Post ...</div>)
    }
  }
}

export default PostDetails
