import React, { Component } from "react"
import PostList from "./PostList"

class PostView extends Component {
  render() {
    return (
      <div className="c-dashboard-grid">
        <div className="c-left-pane">
          <div className="list-action-bar"></div>
          <PostList boardId={this.props.boardId} />
        </div>
      </div>
    )
  }
}

export default PostView