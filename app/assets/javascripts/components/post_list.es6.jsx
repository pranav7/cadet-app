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
    this.handleSortSelectChange = this.handleSortSelectChange.bind(this);
    this.renderPostList = this.renderPostList.bind(this);

    this.getPosts();
  }

  getPosts(options = {}) {
    let that = this;
    let searchTerm = options["searchTerm"];
    let sortBy = options["sortBy"];
    let url = null;
      
    if (searchTerm) {
      url = `/${this.state.boardId}/posts?search=${searchTerm}`
    } else if (sortBy) {
      url = `/${this.state.boardId}/posts?sort_by=${sortBy}`
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

  handleSortSelectChange(value) {
    this.getPosts({sortBy: value});
  }

  search() {
    this.getPosts({searchTerm: this.state.searchTerm});
  }

  renderPostList() {
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

  componentDidMount() {
    $(".sort-post-dropdown").dropdown({
      onChange: this.handleSortSelectChange
    });
  }

  render() {
    return(
      <div className="ui no margin grid">
        <div className="two column row">
          <div className="no padding column">
            <div className="c labeled field">
              <label>Sort By</label>
              <select name="sort_by" className="ui open dropdown sort-post-dropdown selection">
                <option default value="latest_activity">Latest Activity</option>
                <option value="most_voted">Most Voted</option>
                <option value="sort_by_new">New</option>
                <option value="open">#open</option>
                <option value="planned">#planned</option>
                <option value="developing">#developing</option>
                <option value="released">#released</option>
                <option value="closed">#closed</option>
              </select>
            </div>
          </div>

          <div className="right aligned no padding column">
            <div className="ui icon input field">
              <i className="search icon" />
              <input  type="text"
                      placeholder="Search"
                      value={this.state.searchTerm}
                      onChange={this.handleChange} />
            </div>
          </div>
        </div>

        <div className="row">
          {this.renderPostList()}
        </div>
      </div>
    );
  }
}
