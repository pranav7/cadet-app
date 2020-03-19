import {
  REQUEST_POST,
  RECEIVE_POST,
  RECEIVE_POSTS,
  REQUEST_POSTS,
  FETCH_POSTS_FAILED
} from 'Modules/Posts/Actions';

const initialState = {
  isFetchingPost: false,
  isFetchingPosts: false,
  selectedPost: null,
  posts: []
}

export default (state = initialState, action) => {
  switch (action.type) {
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
        posts: action.posts,
        currentPage: action.x_page,
        totalPosts: action.x_total,
        perPage: action.x_per_page
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

