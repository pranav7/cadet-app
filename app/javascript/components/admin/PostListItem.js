import React from 'react';
import { Link } from 'react-router-dom';

const PostListItem = ({ boardId, selected, post, onPostItemClick }) => {
  let isSelected = selected ? 'selected' : '';
  let path = `/admin/${boardId}/posts/${post.slug}`;

  return (
    <Link
      className={`admin-post-list-item ${isSelected}`}
      to={path}
      onClick={() => {
        onPostItemClick(post.slug);
      }}
    >
      <div className="post-title">{post.title}</div>
      <div className="post-summary c-soft">{post.summary}</div>
      <div className="post-meta c-soft">
        <span>{post.created_at}</span>
        <span>&nbsp;</span>
        <span className={`status o__small ${post.status}`}>{`${post.status}`}</span>
        <span>&nbsp;</span>
        <span className="ui tiny label soft">{post.votes_count} Upvote</span>
        <span>&nbsp;</span>
        <span className="ui tiny label soft">
          <i className="comment outline icon" />
          {post.comments_count}
        </span>
      </div>
    </Link>
  );
};

export default PostListItem;
