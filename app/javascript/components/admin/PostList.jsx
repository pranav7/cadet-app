import React from "react"
import PostListItem from "./PostListItem"
import Cookies from "js-cookie"
import _ from "underscore"
import Posts from "../../wrappers/Posts"

class PostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.match.params.boardId,
      searchTerm: '',
      posts: [],
      suggesting: false,
      searching: false,
      noPosts: false,
      currentSortOrder: this.props.defaultSortOrder
    };

    this.init = this.init.bind(this);
    this.getPosts = this.getPosts.bind(this);
    this.renderPostList = this.renderPostList.bind(this);
  }

  componentDidMount() {
    this.init();
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
    Posts.getAll(this.state.boardId, params)
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

  renderPostList() {
    if (this.state.posts.length > 0) {
      return (
        <div className="post-list-item-container">
          {this.state.posts.map((post) =>
            <React.Fragment key={post.id}>
              <PostListItem boardId={this.state.boardId} post={post} {...this.props} />
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
      <div className="post-list-container">
        {this.renderPostList()}
      </div>
    )
  }
}

export default PostList;
