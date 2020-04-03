import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Dropdown } from 'semantic-ui-react';

import Posts from 'API/Posts';
import { fetchPost, fetchPosts } from 'Modules/Posts/Actions';
import { PostsFilterOptions } from 'Common/constants';
import _ from "underscore";

const statusOptions = [
  {
    text: '#open',
    value: 'open'
  },
  {
    text: '#planned',
    value: 'planned'
  },
  {
    text: '#developing',
    value: 'developing'
  },
  {
    text: '#released',
    value: 'released'
  },
  {
    text: '#closed',
    value: 'closed'
  }
];

class StatusDropdown extends Component {
  constructor(props) {
    super(props);

    this.handleChange = this.handleChange.bind(this);
  }

  handleChange(e, { name, value }) {
    const postsApi = new Posts(this.props.boardId, { postId: this.props.postId });
    const data = {
      post: {
        status: value
      }
    };

    postsApi.update(data)
      .then(response => {
        const currentSortOrder = Cookies.get("currentSortOrder");
        this.props.dispatch(fetchPost(this.props.boardId, this.props.postId));
        this.props.dispatch(fetchPosts({
          boardId:this.props.boardId,
          params: {
            sort_by: currentSortOrder
          }
        }));
      });
  }

  render() {
    return(
      <Dropdown
        className="ui tiny button"
        floating
        text="Status"
        options={PostsFilterOptions.filter(option => option.type === 'status' )}
        onChange={this.handleChange}
      />
    );
  }
}

export default connect()(StatusDropdown);
