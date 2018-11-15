import { combineReducers } from 'redux';
import PostReducer from 'Modules/Posts/Reducer';

export default combineReducers({
  selectedPost: PostReducer
});
