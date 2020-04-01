import React, { useState } from 'react'
import renderHTML from 'react-render-html'
import User from './User'
import CommentAPI from 'API/Comment';
import CommentInput from 'AdminComponents/CommentInput';
import { Button, Modal, Form, Input, TextArea } from "semantic-ui-react";

const Comment = ({id, content, commenter, created_at, isNote, isEditable = false, isPost = false, boardId, postId, onChange }) => {

  const [isEditingComment, setIsEditingComment] = useState(false);
  const [isEditingNote, setIsEditingNote] = useState(false);

  const toggleEditCommentModalVisibility = (type) => {
    if(type === 'comment') {
      setIsEditingComment(!isEditingComment);
    } else if(type === 'note') {
      setIsEditingNote(!isEditingNote);
    } else {
      console.error('this should never happen!');
    }
  };

  const onUpdate = (commemt, commentType) => {
    const api = new CommentAPI(boardId, postId, id);
    api.update({
      content_attributes: {
        body: commemt
      }
    }).then(_ => {
      onChange();
      toggleEditCommentModalVisibility(commentType);
    });
  };

  const handleDeleteComment = () => {
    const api = new CommentAPI(boardId, postId, id);
    if(confirm('Are you sure you want to delete this comment? Please note that this step is IRREVERSIBLE.')) {
      api.delete().then(_ => {
        onChange();
      });
    }
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
                      <a class="c thin soft underlined link pointer" onClick={() => toggleEditCommentModalVisibility('note')}>Edit</a>
                    }
                    centered={false}
                    open={isEditingNote}
                    onClose={() => setIsEditingNote(false)}
                    size="tiny"
                  >
                    <Modal.Content>
                      <Modal.Description>
                        <CommentInput
                          boardId={boardId}
                          postId={postId}
                          renderNoteOnly={true}
                          commentId={id}
                          value={{note:content.raw}}
                          onSubmit={(comment) => onUpdate(comment,'note')}
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
                      <a class="c thin soft underlined link pointer" onClick={() => toggleEditCommentModalVisibility('comment')}>Edit</a>
                    }
                    centered={false}
                    open={isEditingComment}
                    onClose={() => setIsEditingComment(false)}
                    size="tiny"
                  >
                    <Modal.Content>
                      <Modal.Description>
                        <CommentInput
                          boardId={boardId}
                          postId={postId}
                          renderCommentOnly={true}
                          value={{comment:content.raw}}
                          onSubmit={(comment) => onUpdate(comment,'comment')}
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
