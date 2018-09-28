import React from "react";
import PostListItem from "./PostListItem";
import Cookies from "js-cookie";
import _ from "underscore";
import Posts from "../wrappers/Posts";

class PostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.boardId,
      searchTerm: '',
      posts: [],
      suggesting: false,
      searching: false,
      noPosts: false,
      currentSortOrder: this.props.defaultSortOrder
    };

    this.init = this.init.bind(this);
    this.getPosts = this.getPosts.bind(this);
    this.getMorePosts = this.getMorePosts.bind(this);
    this.search = this.search.bind(this);
    this.handleSearchInput = this.handleSearchInput.bind(this);
    this.handleSortSelectChange = this.handleSortSelectChange.bind(this);
    this.suggestPosts = this.suggestPosts.bind(this);
    this.renderPostList = this.renderPostList.bind(this);
    this.renderHeader = this.renderHeader.bind(this);
    this.renderSortDropdown = this.renderSortDropdown.bind(this);
    this.restoreScrollPosition = this.restoreScrollPosition.bind(this);
    this.onScroll = this.onScroll.bind(this);
  }

  componentDidMount() {
    this.init();

    window.addEventListener('scroll', this.onScroll, false); 
    $('#post_title').on("input", this.suggestPosts);
    setTimeout(this.restoreScrollPosition, 940);
  }

  componentWillUnmount() {
    window.removeEventListener('scroll', this.onScroll, false);
  }

  init() {
    if (_.isUndefined(Cookies.get("currentSortOrder"))) {
      this.getPosts();
    } else {
      this.state.currentSortOrder = Cookies.get("currentSortOrder")
      this.getPosts({ sort_by: this.state.currentSortOrder })
    }
  }

  getPosts(params = {}) {
    Posts.get(this.state.boardId, params)
      .then((response) => {
        this.setState({
          posts: response.posts,
          currentPage: parseInt(response.headers["x-page"]),
          totalPosts: parseInt(response.headers["x-total"]),
          perPage: parseInt(response.headers["x-per-page"])
        })

        if (response.posts.length == 0) {
          this.setState({ noPosts: true });
        }
      })
      .catch(() => {
        this.setState({ noPosts: true });
      })
  }

  getMorePosts(params = {}) {
    Posts.get(this.state.boardId, params)
      .then(response => {
        let existingPosts = this.state.posts

        this.setState({
          posts: existingPosts.concat(response.posts),
          currentPage: parseInt(response.headers["x-page"]),
          isFetching: false
        });
      })
  }

  handleSearchInput(event) {
    if (event.target.value == "") {
      this.setState({ searchTerm: event.target.value,
        searching: false }, this.search);
    } else {
      this.setState({ searchTerm: event.target.value,
        searching: true }, this.search);
    }
  }

  handleSortSelectChange(value) {
    Cookies.set("currentSortOrder", value, { expires: 1 });
    this.getPosts({ sort_by: value });
  }

  search() {
    this.getPosts({ search: this.state.searchTerm });
  }

  suggestPosts(event) {
    if (event.target.value == "") {
      this.setState({ suggesting: false });
    } else {
      this.setState({ suggesting: true });
    }

    this.getPosts({ search: event.target.value });
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
      <select name="sort_by"
              className="ui open dropdown sort-post-dropdown selection"
              defaultValue={this.state.currentSortOrder}>
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

  renderPostList() {
    if (this.state.posts.length > 0) {
      return (
        <div className="post-list-item-container">
          {this.state.posts.map((post) =>
            <React.Fragment key={post.id}>
              <PostListItem boardId={this.state.boardId} post={post} />
            </React.Fragment>
          )}
        </div>
      );
    } else if (!this.state.noPosts && !this.state.searching && !this.state.suggesting) {
      return(<div className="ui active centered inline loader"></div>);
    } else {
      return(<div className="post-list-item">There are no matching posts</div>);
    }
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

  onScroll() {
    if ((window.innerHeight + window.scrollY) >= (this._getDocHeight() - 500)
      && !this.state.isFetching) {

      let nextPage = this.state.currentPage + 1
      let totalPages = Math.ceil(this.state.totalPosts / this.state.perPage)
      
      if (nextPage <= totalPages) {
        this.setState({ isFetching: true })
        this.getMorePosts({
          sorty_by: this.state.currentSortOrder,
          page: nextPage
        });
      }
    }
  }

  restoreScrollPosition() {
    let scrollPos = Cookies.get("scrollPos")
    if (!_.isUndefined(scrollPos) && scrollPos != "0") {
      $(window).scrollTop(scrollPos);
      Cookies.remove("scrollPos")
    }
  }

  _getDocHeight() {
    return Math.max(
      document.body.scrollHeight, document.documentElement.scrollHeight,
      document.body.offsetHeight, document.documentElement.offsetHeight,
      document.body.clientHeight, document.documentElement.clientHeight
    );
  }
}

export default PostList;
