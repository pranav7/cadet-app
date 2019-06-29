import React from 'react'
import renderHTML from 'react-render-html'
import User from './User'

const Comment = ({id, content, commenter, created_at, isNote}) => { 
  if (isNote) {
    return (
      <div className="comment-container">
        <div className="note">
          <div className="user">{commenter.name}</div>
          <div className="content box">
            {renderHTML(content.body)}
            <div className="meta-info soft">
              {created_at}
            </div>
          </div>
        </div>
      </div>
    )
  } else {
    return (
      <div className="comment-container">
        <div className="comment box">
          <User
            name={commenter.name}
            initials={commenter.initials}
            role={commenter.role} />

          <div className="content">
            {renderHTML(content.body)}
          </div>

          <div className="meta-info soft">
            {created_at}
          </div>
        </div>
      </div>
    )
  }
}

export default Comment
