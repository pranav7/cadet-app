import React from 'react';

const StatusChangedEvent = ({ admin , createdAt, children }) => {
  return (
    <div class="activity-log-item status-changed-event" style={{ padding: '8px 4px' }}>
      <span class="username">{admin.name}</span>
      {children}
      <span class="timestamp">
        {createdAt}
      </span>
    </div>
  )
};

export default StatusChangedEvent;
