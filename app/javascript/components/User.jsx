import React from 'react'

const User = function({name, initials, role, avatarSize=null}) {
  return (
    <div className="user">
      <div className={`avatar circle ${avatarSize}`}>
        <div className="initials">{initials}</div>
      </div>
      <div className="details">
        <span className="name">{name}</span>
      </div>
    </div>
  )
}

export default User
