import React, { Component } from "react"
import { BrowserRouter, Route } from 'react-router-dom'
import PostView from "./admin/PostView"

class AdminApp extends Component {
  render() {
    return (
      <BrowserRouter>
        <div className="AdminApp">
          <Route  path="/admin/:boardId/posts/:postId"
                  render={(props) => <PostView {...props} boardId={this.props.boardId} />} />
        </div>
      </BrowserRouter>
    )
  }
}

export default AdminApp