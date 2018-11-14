export default (state = null, action) => {
  switch(action.type) {
    case 'UPVOTED':
      let newState = {...state};
      newState.voters.push(action.voter)
      return newState;
    case 'POST_FETCHED':
      console.log("POST_FETCHED", action)
      return action.post;
    default:
      return state;
  }
}
