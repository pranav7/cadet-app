import React from "react";
import UpvoteButton from "../UpvoteButton";
import { Link } from 'react-router-dom'

const PostListItem = ({post, boardId}) => {
  return (
    <Link className="admin-post-list-item" to={`/admin/${boardId}/${post.slug}`}>
      <div className="post-title">{post.title}</div>
      <div className="post-summary c-soft">{post.summary}</div>
      <div className="post-meta c-soft">
        <span>{post.created_at}</span>
        <span>&nbsp;</span>
        <span className={`small status ${post.status}`}>
          {`#${post.status}`}
        </span>
        <span>&nbsp;</span>
        <span className="ui rounded tiny label soft">
          {post.votes_count} Upvote
        </span>
        <span>&nbsp;</span>
        <span className="ui rounded tiny label soft">
          <i className="comment outline icon" />
          {post.comments_count}
        </span>
      </div>
    </Link>
  );
}

export default PostListItem
