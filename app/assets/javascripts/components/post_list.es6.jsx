class PostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.boardId,
      searchTerm: '',
      posts: []
    };

    this.getPosts = this.getPosts.bind(this);
    this.search = this.search.bind(this);
    this.handleChange = this.handleChange.bind(this);
    this.postList = this.postList.bind(this);

    this.getPosts();
  }

  getPosts(options = {}) {
    let that = this;
    let searchTerm = options["searchTerm"];
    let url = null;
      
    if (searchTerm) {
      url = `/${this.state.boardId}/posts?search=${searchTerm}`
    } else {
      url = `/${this.state.boardId}/posts`
    }
      
    axios({
      method: "GET",
      url: url,
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

  handleChange(event) {
    this.setState({ searchTerm: event.target.value }, this.search);
  }

  search() {
    this.getPosts({searchTerm: this.state.searchTerm});
  }

  postList() {
    if (this.state.posts.length > 0) {
      return (
        <div>
          {this.state.posts.map((post) =>
            <div key={post.id}>
              <PostListItem boardId={this.state.boardId} post={post} />
            </div>
          )}
        </div>
      );
    } else {
      return(<div className="post-list-item">Your search did not match any post</div>);
    }
  }

  render() {
    return(
      <div>
        <div className="ui icon input field">
          <i className="search icon" />
          <input  type="text"
                  placeholder="Search..."
                  value={this.state.searchTerm}
                  onChange={this.handleChange} />
        </div>
        {this.postList()}
      </div>
    );
  }
}
