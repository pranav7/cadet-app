import React, { Component } from "react";
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { createStore } from "redux";
import { Provider } from 'react-redux';

import PostDetails from "AdminComponents/PostDetails";
import PostList from "AdminComponents/PostList";
import RootReducer from "Store/RootReducer";

const store = createStore(RootReducer);

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
      <Provider store={store}>
        <Router>
          <div className="AdminApp c-dashboard-grid">
            {routes.map((route, index) => (
              <Route
                key={index}
                path={route.path}
                exact={route.exact}
                component={route.sidebar}
              />
            ))}
            {routes.map((route, index) => (
              <Route
                key={index}
                path={route.path}
                exact={route.exact}
                component={route.main}
              />
            ))}
          </div>
        </Router>
      </Provider>
    )
  }
}

export default AdminApp
