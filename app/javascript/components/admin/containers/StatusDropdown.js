import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Dropdown } from 'semantic-ui-react';

import Posts from 'API/Posts';
import { fetchPost, fetchPosts } from 'Modules/Posts/Actions';

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
        this.props.dispatch(fetchPost(this.props.boardId, this.props.postId));
        this.props.dispatch(fetchPosts(this.props.boardId));
      });
  }

  render() {
    return(
      <span>
        <Dropdown
          className="posts__status-dropdown"
          simple
          text="Status"
          options={statusOptions}
          onChange={this.handleChange}
        />
      </span>
    );
  }
}

export default connect()(StatusDropdown);
