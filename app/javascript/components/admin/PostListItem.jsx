import React from "react";
import { Link } from 'react-router-dom'

class PostListItem extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      path: `/admin/${this.props.boardId}/posts/${this.props.post.slug}`
    }

    this.handleLinkClick = this.handleLinkClick.bind(this)
  }

  handleLinkClick(e) {
    [].forEach.call(document.querySelectorAll('.admin-post-list-item'), (element) => {
      element.classList.remove("selected")
    })

    document.getElementById(`post-${this.props.post.id}`).classList.add("selected")
    this.props.history.push(this.state.path)
  }

  render() {
    return (
      <Link className="admin-post-list-item"
            id={`post-${this.props.post.id}`}
            to={this.state.path}
            onClick={this.handleLinkClick} >
        <div className="post-title">{this.props.post.title}</div>
        <div className="post-summary c-soft">{this.props.post.summary}</div>
        <div className="post-meta c-soft">
          <span>{this.props.post.created_at}</span>
          <span>&nbsp;</span>
          <span className={`small status ${this.props.post.status}`}>
            {`#${this.props.post.status}`}
          </span>
          <span>&nbsp;</span>
          <span className="ui rounded tiny label soft">
            {this.props.post.votes_count} Upvote
          </span>
          <span>&nbsp;</span>
          <span className="ui rounded tiny label soft">
            <i className="comment outline icon" />
            {this.props.post.comments_count}
          </span>
        </div>
      </Link>
    )
  }
}

export default PostListItem
