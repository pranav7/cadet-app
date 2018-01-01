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

  handleChange(event) {
    this.setState({ searchTerm: event.target.value }, this.search);
  }

  search() {
    axios({
      method: "GET",
      url: `/${this.state.boardId}/posts?search=${this.state.searchTerm}`,
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
        <div className="ui input field">
          <input  type="text"
                  placeholder="Search ..."
                  value={this.state.searchTerm}
                  onChange={this.handleChange} />
        </div>
        {this.state.posts.map((post) =>
          <div key={post.id}>
            <PostListItem boardId={this.state.boardId} post={post} />
          </div>
        )}
      </div>
    );
  }
}
