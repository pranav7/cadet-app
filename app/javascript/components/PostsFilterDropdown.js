import React from 'react';
import { Dropdown } from 'semantic-ui-react';
import { PostsFilterOptions } from 'Common/constants';

const PostsFilterDropDown = ({ value, onChange }) => {
  return (
      <Dropdown
        text={<strong>{PostsFilterOptions.find(option => option.value === value).text}</strong>}
        icon='dropdown'
        floating
        labeled
        className='icon'
      >
        <Dropdown.Menu style={{ maxHeight: 250, overflow: 'auto' }}>
          <Dropdown.Header content='Sort By' />
          {PostsFilterOptions.filter(option => option.type === 'sort').map(option => (
            <Dropdown.Item
              key={option.value}
              onClick={() => onChange(option.value)}
              active={option.value === value}
            >
              {option.text}
            </Dropdown.Item>
          ))}
          <Dropdown.Divider />
          <Dropdown.Header content='Filter By' />
          {PostsFilterOptions.filter(option => option.type === 'status').map(option => (
            <Dropdown.Item
              key={option.value}
              onClick={() => onChange(option.value)}
              active={option.value === value}
            >
              {option.text}
            </Dropdown.Item>
          ))}
        </Dropdown.Menu>
      </Dropdown>
    );
};

export default PostsFilterDropDown;
