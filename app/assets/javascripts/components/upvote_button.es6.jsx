class UpvoteButton extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      upvoted: this.props.upvoted,
      voteCount: this.props.voteCount
    };

    this.clickListener = this.clickListener.bind(this);
 }

  clickListener() {
    if (this.state.upvoted) {
      this.setState({
        voteCount: this.state.voteCount - 1,
        upvoted: false
      });
    } else {
      this.setState({
        voteCount: this.state.voteCount + 1,
        upvoted: true
      })
    }
  }

  render() {
    return (
      <a className={this.state.upvoted ? 'upvoted vote-button' : 'vote-button'} onClick={this.clickListener}>
        <span className="text">{this.state.upvoted ? 'Upvoted' : 'Upvote'}</span>
        <span className="vote-count">{this.state.voteCount}</span>
      </a>
    );
  }
}
