import { combineReducers } from 'redux';
import PostReducer from 'Modules/Posts/Reducer';

const initialState = {
  selectedPost: null,
  posts: []
}

export default combineReducers({
  PostReducer
});
