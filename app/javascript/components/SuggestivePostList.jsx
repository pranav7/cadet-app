import React from "react";
import PostListItem from "./PostListItem";

class SuggestivePostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.boardId,
      searchTerm: '',
      posts: []
    }

    this.getPosts = this.getPosts.bind(this);
    this.suggestPosts = this.suggestPosts.bind(this);
    this.renderPostList = this.renderPostList.bind(this);
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

  suggestPosts(event) {
    this.state.searchTerm = event.target.value
    this.getPosts({ search: this.state.searchTerm });
  }

  renderPostList() {
    if (this.state.posts.length > 0 && this.state.searchTerm != '') {
      return (
        <div className="post-list-item-container">
          <span className="suggestive-heading">
            Are these posts similar to your post?
          </span>

          {this.state.posts.map((post) =>
            <React.Fragment key={post.id}>
              <PostListItem boardId={this.state.boardId} post={post} />
            </React.Fragment>
          )}
        </div>
      );
    }
  }

  render() {
    return(
      <div className="ui no margin grid">
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

export default SuggestivePostList;
