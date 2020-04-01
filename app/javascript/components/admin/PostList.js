import React from "react";
import { connect } from "react-redux";
import { Container, Icon } from "semantic-ui-react";

import PostListItem from "./PostListItem";
import Cookies from "js-cookie";
import _ from "underscore";
import { fetchPosts } from "Modules/Posts/Actions";
import CreatePostModal from "AdminContainers/CreatePostModal";
import { Dropdown } from 'semantic-ui-react'

const sortOptions = [
  {
    text: 'Latest Activity',
    value: 'latest_activity'
  },
  {
    text: 'Most Voted',
    value: 'most_voted'
  },
  {
    text: 'Most Recent',
    value: 'most_recent'
  }
];

const filterOptions = [
  {
    text: '#Open',
    value: 'open'
  },
  {
    text: '#Planned',
    value: 'planned'
  },
  {
    text: '#Developing',
    value: 'developing'
  },
  {
    text: '#Released',
    value: 'released'
  },
  {
    text: '#Closed',
    value: 'closed'
  }
];

class PostList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      boardId: this.props.match.params.boardId,
      searchTerm: "",
      loading: false,
      currentPage: 1,
    };

    this.listContainerNode = React.createRef();
    this.onScroll = this.onScroll.bind(this);
  }

  componentWillUnmount() {
    this.listContainerNode.removeEventListener("scroll", this.onScroll, false);
  }

  componentDidMount() {
    if (_.isUndefined(Cookies.get("currentSortOrder"))) {
      this.getPosts();
    } else {
      this.state.currentSortOrder = Cookies.get("currentSortOrder");
      this.getPosts({ sort_by: this.state.currentSortOrder });
    }

    this.listContainerNode.addEventListener("scroll", this.onScroll, false);
    $("#post_title").on("input", this.suggestPosts);
    setTimeout(this.restoreScrollPosition, 940);
  }

  restoreScrollPosition() {
    let scrollPos = Cookies.get("scrollPos");
    if (!_.isUndefined(scrollPos) && scrollPos != "0") {
      $(window).scrollTop(scrollPos);
      Cookies.remove("scrollPos");
    }
  }

  onScroll() {
    if (
      this.listContainerNode && this.listContainerNode.offsetHeight + this.listContainerNode.scrollTop >= this.listContainerNode.scrollHeight &&
      !this.props.isFetchingPosts
    ) {
      let nextPage = this.props.currentPage + 1;
      let totalPages = Math.ceil(this.props.totalPosts / this.props.perPage);

      if (nextPage <= totalPages) {
        this.setState({ isFetching: true });
        this.getPosts({
          sorty_by: this.state.currentSortOrder,
          page: nextPage
        });
      }
    }
  }

  getPosts = (params = {}, flushPosts = false) => {
    this.props.dispatch(fetchPosts(this.state.boardId, params, flushPosts));
  };

  handleSearchInput = event => {
    if (event.target.value == "") {
      this.setState(
        { searchTerm: event.target.value, loading: false },
        this.search
      );
    } else {
      this.setState(
        { searchTerm: event.target.value, loading: true },
        this.search
      );
    }
  };

  search = () => {
    this.getPosts({ search: this.state.searchTerm }, true);
  };

  handlePostItemClick = slug => {
    this.setState({ currentSelected: slug });
  };

  renderPostList = () => {
    if (this.props.posts.length > 0) {
      return (
        <div className="post-list-item-container">
          {this.props.posts.map(post => (
            <React.Fragment key={post.id}>
              <PostListItem
                boardId={this.state.boardId}
                selected={this.state.currentSelected == post.slug}
                post={post}
                onPostItemClick={this.handlePostItemClick}
                {...this.props}
              />
            </React.Fragment>
          ))}
        </div>
      );
    } else if (!this.props.noPosts && this.props.isFetchingPosts) {
      return (
        <Container textAlign="center" className="top padded">
          <Icon loading name="circle notch" size="large" color="grey" />
        </Container>
      );
    } else {
      return (
        <div className="t__soft u__pt__x2 u__pl__x4">
          There are no matching posts
        </div>
      );
    }
  };

  renderSortDropdown() {
    $(".sort-post-dropdown").dropdown({
      onChange: (value) => this.getPosts({ sort_by: value }, true)
    });

    return (
      <select
        name="sort_by"
        className="ui open dropdown sort-post-dropdown button"
        defaultValue={this.state.currentSortOrder}
      >
        <div class="text">{this.state.currentSortOrder || sortOptions[0].text}</div>
        <div class="menu">
          <div class="header">Sort By</div>
          {sortOptions.map(option => (
            <div class="item" key={option.value} data-value={option.value}>
              {option.text}
            </div>
          ))}
          <div class="header">Filter By</div>
          {filterOptions.map(option => (
            <div class="item" key={option.value} data-value={option.value}>
              {option.text}
            </div>
          ))}
        </div>
      </select>
    );
  }

  render() {
    return (
      <div className="c-left-pane">
        <div className="list-action-bar">
          <div className="container-one">
            <div className="c-breadcrumb">
              <div className="section">
                <a>Boards</a>
              </div>
              <div className="divider">/</div>
              <div className="section active">
                <a>Feature Requests</a>
              </div>
            </div>

            <CreatePostModal boardId={this.state.boardId} />
          </div>
          <div className="container-two">
            <div className="ui icon fluid input field">
              <i className="search icon"></i>
              <input
                type="text"
                placeholder="Search"
                value={this.state.searchTerm}
                onChange={this.handleSearchInput}
              />
            </div>
          </div>
          <div className="c labeled field">
              <label>Show</label>
              {this.renderSortDropdown()}
          </div>
        </div>
        <div className="post-list-container" ref={(node) => this.listContainerNode = node}>{this.renderPostList()}</div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return {
    isFetchingPosts: state.isFetchingPosts,
    noPosts: state.noPosts,
    posts: state.posts,
    currentPage: state.currentPage,
    totalPosts: state.totalPosts,
    perPage: state.perPage
  };
};

export default connect(mapStateToProps)(PostList);
