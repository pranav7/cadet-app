class PostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.boardId,
      posts: []
    };

    this.getPosts = this.getPosts.bind(this);
    this.getPosts();
  }

  getPosts() {
    let that = this;
    axios({
      method: "GET",
      url: `/${this.state.boardId}/posts`,
      headers: {
        'Content-Type': "application/json",
        'Accept': "application/json",
        'X-CSRF-Token': document.querySelector("meta[name=csrf-token]").content
      }
    })
    .then(response => {
      this.setState({
        posts: response.data.posts
      });
    });
  }

  render() {
    return(
      <div>
        {this.state.posts.map((post) =>
          <PostListItem boardId={this.state.boardId} post={post} />
        )}
      </div>
    );
  }
}
