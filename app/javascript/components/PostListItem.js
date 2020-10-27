import React from 'react';
import UpvoteButton from './UpvoteButton';
import Cookies from 'js-cookie';

const PostListItem = ({ post, boardId }) => {
  function handlePostItemClick() {
    Cookies.set('scrollPos', $(window).scrollTop());
  }

  return (
    <div className="post-list-item">
      <div className="post-body">
        <a className="post-link" href={post.url} onClick={handlePostItemClick}>
          <div className="title-text float left">{post.title}</div>
          <div className="post-summary">{post.summary}</div>
        </a>
        <div className="comment-count soft float right">
          <i className="comment outline icon" />
          {post.comments_count}
        </div>
      </div>
      <div className="post-info soft">
        <UpvoteButton
          voteCount={post.votes_count}
          upvoted={post.upvoted}
          boardId={boardId}
          postId={post.id}
        />
        <div className="meta">
          <strong className={`status ${post.status}`}>{post.status}</strong>
          <span className="dates">
            {post.created_at} by {post.created_by}
          </span>
        </div>
      </div>
    </div>
  );
};

export default PostListItem;
