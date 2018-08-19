import React from "react";
import UpvoteButton from "./UpvoteButton";
import Cookies from "js-cookie";
import $ from "jquery";

class PostListItem extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.boardId,
      post: this.props.post
    };

    this.handlePostItemClick = this.handlePostItemClick.bind(this);
  }

  handlePostItemClick() {
    Cookies.set("scrollPos", $(window).scrollTop())
  }

  render() {
    return (
      <div className="post-list-item">
        <div className="post-body">
          <a  className="post-link"
              href={this.state.post.url}
              onClick={this.handlePostItemClick}>
            <div className="title-text float left">
              {this.state.post.title}
            </div>
            <div className="post-summary">
              {this.state.post.summary}
            </div>
          </a>
          <div className="comment-count soft float right">
            <i className="comment outline icon" />
            {this.state.post.comments_count}
          </div>
        </div>
        <div className="post-info soft">
          <UpvoteButton voteCount={this.state.post.votes_count}
            upvoted={this.state.post.upvoted}
            boardId={this.state.boardId}
            postId={this.state.post.id} />
          <div className="meta">
            <strong className={`status ${this.state.post.status}`}>
              #{this.state.post.status}
            </strong>
            <span className="dates">
              {this.state.post.created_at} by {this.state.post.created_by}
            </span>
          </div>
        </div>
      </div>
    );
  }
}

export default PostListItem;
