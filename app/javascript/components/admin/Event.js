import React from 'react';

const Event = ({ admin , createdAt, children }) => {
  return (
    <div class="activity-log__item">
      <span class="activity-log__username">{admin.name}</span>
      {children}
      <span class="activity-log__timestamp">
        {createdAt}
      </span>
    </div>
  )
};

export default Event;
