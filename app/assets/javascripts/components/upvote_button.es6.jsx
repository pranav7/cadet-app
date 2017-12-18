class UpvoteButton extends React.Component {
  render () {
    return (
      <a className="vote-button large" data-method="post" href="/feature-requests/posts/this-is-an-example-post/votes">
        <span className="text">Upvote</span>
        <span className="vote-count">1</span>
      </a>
    );
  }
}
