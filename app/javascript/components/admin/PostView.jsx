import React, { Component } from "react"
import PostList from "./PostList"
import PostDetails from "./PostDetails"

class PostView extends Component {
  render() {
    return (
      <div className="c-dashboard-grid">
        <div className="c-left-pane">
          <div className="list-action-bar"></div>
          <PostList boardId={this.props.match.params.boardId} />
        </div>
        <div className="c-main-pane">
          <PostDetails  boardId={this.props.match.params.boardId}
                        postId={this.props.match.params.postId} />
        </div>
      </div>
    )
  }
}

export default PostView
