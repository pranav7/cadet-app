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
  RECEIVE_POSTS
} from 'Modules/Posts/Actions';

const initialState = {
  isFetching: false,
  didInvalidate: false,
  selectedPost: null
}

export default (state = initialState, action) => {
  switch (action.type) {
    case UPVOTED:
      let newState = Object.assign({}, state)
      newState.selectedPost.voters.push(action.voter)
      return newState;
    case REQUEST_POST:
      return Object.assign({}, state, {
        isFetching: true,
        didInvalidate: false
      })
    case RECEIVE_POST:
      return Object.assign({}, state, {
        isFetching: false,
        didInvalidate: false,
        selectedPost: action.post
      });
    case RECEIVE_POSTS:
      return Object.assign({}, state, {
        posts: action.posts
      })
    default:
      return state;
  }
}

// export default combineReducers({
//   selectedPost: PostReducer
// });

