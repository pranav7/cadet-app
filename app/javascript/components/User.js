import React from "react";
import { capitalizeFirstLetter } from 'Common/utils';

const User = ({ name, initials, role, avatarSize = null, jobTitle = undefined, companyName = undefined}) => {
  return (
      <div className="user">
        <div className={`avatar circle ${avatarSize}`}>
          <div className="initials">{initials}</div>
        </div>
        <div className="details">
          <span className="name">{name}</span>
          <div>
            <span className="soft meta">
              {jobTitle && `${capitalizeFirstLetter(jobTitle)}`}
              {jobTitle && companyName && ', '}
              {companyName && `${capitalizeFirstLetter(companyName)}`}
            </span>
          </div>
        </div>

        {role == "admin" && (
          <div className="staff-label">
            <span className="ui small basic label float right">Team</span>
          </div>
        )}
      </div>
  );
};

export default User;
