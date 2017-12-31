class PostListItem extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.boardId,
      post: this.props.post
    };
  }

  render() {
    return (
      <div className="post-list-item">
        <div className="post-body">
          <a className="post-link" href={this.state.post.url}>
            <span className="title-text float left">
              <h3>{this.state.post.title}</h3>
            </span>
            <div className="post-summary soft">
              {this.state.post.summary}
            </div>
          </a>
          <div className="comment-count soft float right">
            <i className="comment outline icon" />
            {this.state.post.comments_count}
          </div>
        </div>
        <div className="post-info soft">
          <UpvoteButton voteCount={this.state.post.votes_count} upvoted={this.state.post.upvoted} boardId={this.state.boardId} postId={this.state.post.id} />
          <strong className={`margined left status + ${this.state.post.status}`}>#{this.state.post.status}</strong>
          <span className="margined left">{this.state.post.created_at} by {this.state.post.created_by}</span>
        </div>
      </div>
    );
  }
}


