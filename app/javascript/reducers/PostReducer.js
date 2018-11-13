const PostReducer = (state = [], action) => {
  switch(action.type) {
    case 'UPVOTED':
      return state.concat([action.data]);
    default:
      return state;
  }
}

export default PostReducer;