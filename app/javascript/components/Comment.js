import React, { useState } from 'react'
import renderHTML from 'react-render-html'
import User from './User'
import CommentAPI from 'API/Comment';
import CreateComment from 'AdminComponents/CreateComment';
import { Button, Modal, Form, Input, TextArea } from "semantic-ui-react";

const Comment = ({id, content, commenter, created_at, isNote, isEditable = false, isPost = false, boardId, postId, onChange }) => {

  const [isEditingComment, setIsEditingComment] = useState(false);
  const [isEditingNote, setIsEditingNote] = useState(false);

  const handleEditClick = (type) => {
    if(type === 'comment') {
      setIsEditingComment(true);
    } else if(type === 'note') {
      setIsEditingNote(true);
    } else {
      console.error('this should never happen!');
    }

    // const updatedPost = window.prompt('Edit to?', '');
  };

  const onUpdate = (commemt) => {
    const api = new CommentAPI(boardId, postId, id);
    api.update({
      content_attributes: {
        body: commemt
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
              {
              (!isPost && isEditable) && (
                <React.Fragment>
                  <span class="soft">&nbsp;·&nbsp;</span>
                  <Modal
                    trigger={
                      <a class="c thin soft underlined link pointer" onClick={() => handleEditClick('note')}>Edit</a>
                    }
                    centered={false}
                    open={isEditingNote}
                    onClose={() => setIsEditingNote(false)}
                    size="tiny"
                  >
                    <Modal.Content>
                      <Modal.Description>
                        <CreateComment
                          boardId={boardId}
                          postId={postId}
                          renderNoteOnly={true}
                          commentId={id}
                          value={{note:content.raw}}
                          onSubmit={onUpdate}
                        />
                      </Modal.Description>
                    </Modal.Content>
                  </Modal>
                  <span class="soft">&nbsp;·&nbsp;</span>
                  <a class="c thin soft underlined link pointer" onClick={handleDeleteComment}>Delete</a>
                </React.Fragment>
              )
            }
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
            {
              (!isPost && isEditable) && (
                <React.Fragment>
                  <span class="soft">&nbsp;·&nbsp;</span>
                  <Modal
                    trigger={
                      <a class="c thin soft underlined link pointer" onClick={() => handleEditClick('comment')}>Edit</a>
                    }
                    centered={false}
                    open={isEditingComment}
                    onClose={() => setIsEditingComment(false)}
                    size="tiny"
                  >
                    <Modal.Content>
                      <Modal.Description>
                        <CreateComment
                          boardId={boardId}
                          postId={postId}
                          renderCommentOnly={true}
                          value={{comment:content.raw}}
                          onSubmit={onUpdate}
                        />
                      </Modal.Description>
                    </Modal.Content>
                  </Modal>
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
