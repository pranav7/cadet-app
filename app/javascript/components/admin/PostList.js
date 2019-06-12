import React from "react";
import { connect } from 'react-redux';
import { Container, Icon } from 'semantic-ui-react';

import PostListItem from "./PostListItem";
import Cookies from "js-cookie";
import _ from "underscore";
import { fetchPosts } from 'Modules/Posts/Actions';

class PostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.match.params.boardId
    };

    this.init = this.init.bind(this);
    this.getPosts = this.getPosts.bind(this);
    this.renderPostList = this.renderPostList.bind(this);
    this.handlePostItemClick = this.handlePostItemClick.bind(this);
  }

  componentDidMount() {
    this.init();
  }

  init() {
    if (_.isUndefined(Cookies.get("currentSortOrder"))) {
      this.getPosts();
    } else {
      this.state.currentSortOrder = Cookies.get("currentSortOrder");
      this.getPosts({ sort_by: this.state.currentSortOrder });
    }
  }

  getPosts(params = {}) {
    this.props.dispatch(fetchPosts(this.state.boardId, params));
  }

  handlePostItemClick(slug) {
    this.setState({ currentSelected: slug });
  }

  renderPostList() {
    if (this.props.posts.length > 0) {
      return (
        <div className="post-list-item-container">
          {this.props.posts.map((post) =>
            <React.Fragment key={post.id}>
              <PostListItem boardId={this.state.boardId}
                selected={this.state.currentSelected == post.slug}
                post={post}
                onPostItemClick={this.handlePostItemClick}
                {...this.props} />
            </React.Fragment>
          )}
        </div>
      );
    } else if (!this.props.noPosts &&
      this.props.isFetchingPosts) {
      return(
        <Container textAlign="center" className="top padded">
          <Icon loading name='circle notch' size="large" color="grey" />
        </Container>
      );
    } else {
      return(
        <div className="post-list-item">
          There are no matching posts
        </div>
      );
    }
  }

  render() {
    return(
      <div className="c-left-pane">
        <div className="list-action-bar">
          <div className="container-one">
            <div id="create-post-btn">
              <i className="add square primary big icon button"></i>
            </div>
          </div>
          <div className="container-two">
            <div className="ui icon fluid input field">
              <i className="search icon"></i>
              <input name="search" placeholder="Search Posts"></input>
            </div>
          </div>
        </div>
        <div className="post-list-container">
          {this.renderPostList()}
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    isFetchingPosts: state.isFetchingPosts,
    noPosts: state.noPosts,
    posts: state.posts
  };
};

export default connect(mapStateToProps)(PostList);
