import React from "react";
import { connect } from 'react-redux';
import Posts from 'API/Posts';
import { fetchPost } from 'Modules/Posts/Actions';

class UpvoteButton extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      upvoted: this.props.upvoted,
      voteCount: this.props.voteCount,
      boardId: this.props.boardId,
      postId: this.props.postId
    }

    this.handleClick = this.handleClick.bind(this)
    this.upvote = this.upvote.bind(this)
    this.downvote = this.downvote.bind(this)
    this.toggleUp = this.toggleUp.bind(this)
    this.toggleDown = this.toggleDown.bind(this)
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      upvoted: nextProps.upvoted,
      voteCount: nextProps.voteCount,
      boardId: nextProps.boardId,
      postId: nextProps.postId
    })
  }

  handleClick() {
    if (this.state.upvoted) {
      this.downvote();
    } else {
      this.upvote();
    }
  }

  upvote() {
    const postsApi = new Posts(this.state.boardId, { postId: this.state.postId });

    postsApi.upvote()
      .then(response => {
        this.toggleUp();
      })
      .catch(status => {
        if (status == 401) {
          $("#signup-modal")
            .modal({ duration: 250 })
            .modal("show")
        }
      });
  }

  downvote() {
    const postsApi = new Posts(this.state.boardId, { postId: this.state.postId });

    postsApi.downvote()
      .then(response => {
        this.toggleDown();
      });
  }

  toggleDown() {
    this.setState({
      voteCount: this.state.voteCount - 1,
      upvoted: false
    });

    this.props.dispatch(fetchPost(this.state.boardId, this.state.postId))
  }

  toggleUp() {
    this.setState({
      voteCount: this.state.voteCount + 1,
      upvoted: true
    })

    this.props.dispatch(fetchPost(this.state.boardId, this.state.postId))
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

export default connect()(UpvoteButton);
