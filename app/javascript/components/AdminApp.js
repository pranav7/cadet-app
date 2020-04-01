import React, { Component } from "react";
import { BrowserRouter as Router, Route } from 'react-router-dom';
import thunkMiddleware from 'redux-thunk';
import { createStore, applyMiddleware } from "redux";
import { Provider } from 'react-redux';

import PostDetails from "AdminComponents/PostDetails";
import PostList from "AdminComponents/PostList";
import RootReducer from "Store/RootReducer";

const store = createStore(
  RootReducer,
  applyMiddleware(thunkMiddleware));

class AdminApp extends Component {
  render() {
    const routes = [
      {
        path: "/admin/:boardId/posts/:postId",
        exact: true,
        sidebar: PostList,
        main: (params) => <PostDetails currentUser={this.props.current_user} {...params} />
      }
    ];

    return (
      <Provider store={store}>
        <Router>
          <React.Fragment>
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
          </React.Fragment>
        </Router>
      </Provider>
    )
  }
}

export default AdminApp
