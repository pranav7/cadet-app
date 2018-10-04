import React from 'react'

const User = ({name, initials, role, avatarSize=null}) => {
  return (
    <div className="user">
      <div className={`avatar circle ${avatarSize}`}>
        <div className="initials">{initials}</div>
      </div>
      <div className="details">
        <span className="name">{name}</span>
      </div>

      { role == "admin" &&
        <div className="staff-label">
          <span className="ui small basic label float right">Team</span>
        </div>
      }

    </div>
  )
}

export default User
