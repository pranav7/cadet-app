class PostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.boardId,
      searchTerm: '',
      posts: [],
      suggesting: false,
      searching: false,
      noPosts: false
    };

    this.getPosts = this.getPosts.bind(this);
    this.search = this.search.bind(this);
    this.handleSearchInput = this.handleSearchInput.bind(this);
    this.handleSortSelectChange = this.handleSortSelectChange.bind(this);
    this.suggestPosts = this.suggestPosts.bind(this);
    this.renderPostList = this.renderPostList.bind(this);
    this.renderHeader = this.renderHeader.bind(this);
    this.renderSortDropdown = this.renderSortDropdown.bind(this);

    this.getPosts();
  }

  getPosts(params = {}) {
    let url = null;

    if ($.isEmptyObject(params)) {
      url = `/${this.state.boardId}/posts`
    } else {
      url = `/${this.state.boardId}/posts?${$.param(params)}`
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

      if (response.data.posts.length == 0) {
        this.setState({ noPosts: true })
      }
    });
  }

  handleSearchInput(event) {
    if (event.target.value == "") {
      this.setState({ searchTerm: event.target.value, searching: false }, this.search);
    } else {
      this.setState({ searchTerm: event.target.value, searching: true }, this.search);
    }
  }

  handleSortSelectChange(value) {
    this.getPosts({sort_by: value});
  }

  search() {
    this.getPosts({ search: this.state.searchTerm });
  }

  renderPostList() {
    if (this.state.posts.length > 0) {
      return (
        <div className="post-list-item-container">
          {this.state.posts.map((post) =>
            <div key={post.id}>
              <PostListItem boardId={this.state.boardId} post={post} />
            </div>
          )}
        </div>
      );
    } else if (this.state.noPosts == false && this.state.searching == false && this.state.suggesting == false) {
      return(<div className="ui active centered inline loader"></div>);
    } else {
      return(<div className="post-list-item">There are no matching posts</div>);
    }
  }

  renderHeader() {
    if (this.state.suggesting == true) {
      return (
        <div className="one column row">
          <div className="no padding column">
            <strong>Suggesting posts</strong>
          </div>
        </div>
      )
    } else { 
      return (
        <div className="two column stackable row">
          <div className="no padding column">
            <div className="c labeled field">
              <label>Show</label>
              {this.renderSortDropdown()}
            </div>
          </div>
          <div className="right aligned no padding column">
            <div className="ui icon input field">
              <i className="search icon" />
              <input  type="text"
                      placeholder="Search"
                      value={this.state.searchTerm}
                      onChange={this.handleSearchInput} />
            </div>
          </div>
        </div>
      );
    }
  }

  renderSortDropdown() {
    $(".sort-post-dropdown").dropdown({
      onChange: this.handleSortSelectChange
    });

    return (
      <select name="sort_by" className="ui open dropdown sort-post-dropdown selection" defaultValue={this.props.defaultSortOrder}>
        {Object.entries(this.props.sortOptions).map(([key, value], i) => {
          return (
            <option key={key} value={value}> 
              {key}
            </option>
          )
        })}
      </select>
    )
  }

  suggestPosts(event) {
    if (event.target.value == "") {
      this.setState({ suggesting: false });
    } else {
      this.setState({ suggesting: true });
    }

    this.getPosts({ search: event.target.value });
  }

  render() {
    return(
      <div className="ui no margin grid">
        {this.renderHeader()}

        <div className="row">
          {this.renderPostList()}
        </div>
      </div>
    );
  }

  componentDidMount() {
    $('#post_title').on("input", this.suggestPosts);
  }
}
