import React from 'react';
import {Link, withRouter} from 'react-router-dom';
import {connect} from "react-redux";

const TagPostListItem = ({ post }) => {
  let path = `/admin/${post.board_id}/posts/${post.slug}`;
  const tags = post.tag_list.map(x =>
    <span key={x.id} className="text-sm font-semibold bg-gray-200 py-1 px-2 mr-2 rounded align-middle">{x.name}</span>);

  return (
    <a
      className={`tag-post-list-item mb-4`}
      href={path}
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
      <div className="post-meta c-soft float-right">
        {tags}
      </div>
    </a>
  );
};

export default TagPostListItem;

