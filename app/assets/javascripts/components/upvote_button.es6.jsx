class UpvoteButton extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      upvoted: this.props.upvoted,
      voteCount: this.props.voteCount,
      boardId: this.props.boardId,
      postId: this.props.postId
    };

    this.handleClick = this.handleClick.bind(this);
    this.upvote = this.upvote.bind(this);
    this.downvote = this.downvote.bind(this);
    this.toggleUp = this.toggleUp.bind(this);
    this.toggleDown = this.toggleDown.bind(this);
  }

  handleClick() {
    if (this.state.upvoted) {
      this.downvote();
    } else {
      this.upvote();
    }
  }

  upvote() {
    let that = this;
    axios({
      method: "POST",
      url: `/${this.state.boardId}/posts/${this.state.postId}/votes`,
      headers: {
        'Content-Type': "application/json",
        'Accept': "application/json",
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
      }
    })
    .then(response => {
      that.toggleUp();
    })
    .catch(error => {
      if (error.response.status == 401) {
        $("#signup-modal")
          .modal({ duration: 250 })
          .modal("show")
      }
    });
  }

  downvote() {
    let that = this;
    axios({
      method: "DELETE",
      url: `/${this.state.boardId}/posts/${this.state.postId}/votes`,
      headers: {
        'Content-Type': "application/json",
        'Accept': "application/json",
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
      }
    })
    .then(response => {
      that.toggleDown();
    });
  }

  toggleDown() {
    this.setState({
      voteCount: this.state.voteCount - 1,
      upvoted: false
    });
  }

  toggleUp() {
    this.setState({
      voteCount: this.state.voteCount + 1,
      upvoted: true
    })
  }

  render() {
    return (
      <a className={this.state.upvoted ? 'upvoted vote-button' : 'vote-button'} onClick={this.handleClick}>
        <span className="text">{this.state.upvoted ? 'Upvoted' : 'Upvote'}</span>
        <span className="vote-count">{this.state.voteCount}</span>
      </a>
    );
  }
}
