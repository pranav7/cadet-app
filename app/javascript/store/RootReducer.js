/* {
 *    isFetching: <true/false>,
 *    didInvalidate: <true/false>,
 *    lastUpdated: <Timestamp>,
 *    selectedPost: {
 *      id: 10,
 *      title: "",
 *      comments: [],
 *      voters: []
 *    },
 *    posts: []
 * }
 */

// import { combineReducers } from 'redux';
import {
  UPVOTED,
  REQUEST_POST,
  RECEIVE_POST,
  RECEIVE_POSTS,
  REQUEST_POSTS,
  FETCH_POSTS_FAILED
} from 'Modules/Posts/Actions';

const initialState = {
  isFetching: false,
  didInvalidate: false,
  selectedPost: null,
  posts: []
}

export default (state = initialState, action) => {
  switch (action.type) {
    case UPVOTED:
      let newState = Object.assign({}, state)
      newState.selectedPost.voters.push(action.voter)
      return newState;
    case REQUEST_POST:
      return Object.assign({}, state, {
        isFetchingPost: true,
        didInvalidate: false
      })
    case RECEIVE_POST:
      return Object.assign({}, state, {
        isFetchingPost: false,
        didInvalidate: false,
        selectedPost: action.post
      });
    case REQUEST_POSTS:
      return Object.assign({}, state, {
        isFetchingPosts: true
      })
    case RECEIVE_POSTS:
      return Object.assign({}, state, {
        isFetchingPosts: false,
        posts: action.posts
      })
    case FETCH_POSTS_FAILED:
      return Object.assign({}, state, {
        isFetchingPosts: false,
        noPosts: true
      })
    default:
      return state;
  }
}

// export default combineReducers({
//   selectedPost: PostReducer
// });

