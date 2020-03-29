import React from 'react'
import renderHTML from 'react-render-html'
import User from './User'
import CommentAPI from 'API/Comment';

const Comment = ({id, content, commenter, created_at, isNote, isEditable = false, isPost = false, boardId, postId, onChange }) => {
  const handleEditComment = () => {
    const updatedPost = window.prompt('Edit to?', '');
    const api = new CommentAPI(boardId, postId, id);
    api.update({
      content_attributes: {
        body: updatedPost
      }
    }).then(_ => onChange());
  };

  const handleDeleteComment = () => {
    const api = new CommentAPI(boardId, postId, id);
    api.delete();
  };

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
            {(!isPost && isEditable) ? "Edit" : 'Cannot Edit'}
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
            {
              (!isPost && isEditable) && (
                <React.Fragment>
                  <span class="soft">&nbsp;·&nbsp;</span>
                  <a class="c thin soft underlined link pointer" onClick={handleEditComment}>Edit</a>
                  <span class="soft">&nbsp;·&nbsp;</span>
                  <a class="c thin soft underlined link pointer" onClick={handleDeleteComment}>Delete</a>
                </React.Fragment>
              )
            }
          </div>
        </div>
      </div>
    )
  }
}

export default Comment
