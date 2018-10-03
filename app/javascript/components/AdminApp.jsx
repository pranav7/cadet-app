import React, { Component } from "react"
import { BrowserRouter as Router, Route } from 'react-router-dom'
import PostDetails from "./admin/PostDetails";
import PostList from "./admin/PostList";

class AdminApp extends Component {
  render() {
    const routes = [
      {
        path: "/admin/:boardId/posts/:postId",
        exact: true,
        sidebar: PostList,
        main: PostDetails
      }
    ];

    return (
      <Router>
        <div className="AdminApp c-dashboard-grid">
          <div className="c-left-pane">
            <div className="list-action-bar"></div>
            {routes.map((route, index) => (
              <Route
                key={index}
                path={route.path}
                exact={route.exact}
                component={route.sidebar}
              />
            ))}
          </div>
          <div className="c-main-pane">
            {routes.map((route, index) => (
              <Route
                key={index}
                path={route.path}
                exact={route.exact}
                component={route.main}
              />
            ))}
          </div>
          <div className="c-right-pane"></div>
        </div>
      </Router>
    )
  }
}

export default AdminApp
