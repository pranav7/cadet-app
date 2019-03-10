import React, { Component } from 'react';
import { Dropdown } from 'semantic-ui-react';

import Posts from 'API/Posts';

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
        console.log("updated", response);
      })
      .catch(response => {
        console.log("failed", response);
      });
  }

  render() {
    return(
      <span>
        Status{' '}
        <Dropdown
          inline
          options={statusOptions}
          onChange={this.handleChange}
        />
      </span>
    );
  }
}

export default StatusDropdown;
