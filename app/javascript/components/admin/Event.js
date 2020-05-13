import React from 'react';

const StatusChangedEvent = ({ admin , createdAt, children }) => {
  return (
    <div class="activity-log__item" style={{ padding: '8px 4px' }}>
      <span class="activity-log__username">{admin.name}</span>
      {children}
      <span class="activity-log__timestamp">
        {createdAt}
      </span>
    </div>
  )
};

export default StatusChangedEvent;
