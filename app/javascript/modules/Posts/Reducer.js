import {
  UPVOTED,
  POST_FETCHED
} from 'Modules/Posts/Actions';

export default (state = null, action) => {
  switch (action.type) {
    case UPVOTED:
      let newState = Object.assign({}, state)
      newState.voters.push(action.voter)
      return newState;
    case POST_FETCHED:
      return Object.assign({}, state, action.post);
    default:
      return state;
  }
}
