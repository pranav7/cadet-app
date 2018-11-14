import React from "react";
import PostListItem from "Components/PostListItem";
import Posts from "API/Posts";
import RootReducer from "Store/RootReducer";

import { createStore } from "redux";
import { Provider } from 'react-redux';

const store = createStore(RootReducer);

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
    let postsApi = new Posts(this.state.boardId)

    postsApi.getMany(params)
      .then((response) => {
        this.setState({ posts: response.posts });
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
      <Provider store={store}>
        <div className="ui no margin grid">
          <div className="row">
            {this.renderPostList()}
          </div>
        </div>
      </Provider>
    );
  }

  componentDidMount() {
    $('#post_title').on("input", this.suggestPosts);
  }
}

export default SuggestivePostList;
