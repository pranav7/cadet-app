import React from 'react';
import { Dropdown } from 'semantic-ui-react';

const statusOptions = [
  {
    text: '#planned',
    value: 'planned'
  },
  {
    text: '#developing',
    value: 'developing'
  }
];

const StatusDropdown = () => (
  <span>
    Status{' '}
    <Dropdown inline options={statusOptions} />
  </span>
)

export default StatusDropdown;
