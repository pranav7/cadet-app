import React from 'react';

const StatusChangedEvent = ({ event: { admin_username, old_value, new_value } , createdAt }) => {
  const statuses = [ 'open', 'planned', 'developing', 'released', 'closed' ];
  return (
    <div style={{ padding: '8px 4px' }}>
      <span>
        <strong>{admin_username} &nbsp;</strong>
        <span>changed the status to &nbsp;</span>
        <strong class={`status o__small ${statuses[new_value]}`}>
          #{statuses[new_value]}
        </strong>
        &nbsp;
        <span>
          {createdAt}
        </span>
      </span>
    </div>
  )
};

export default StatusChangedEvent;
