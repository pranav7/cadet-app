import Posts from 'API/Posts';

export const UPVOTED = 'UPVOTED';
export const DOWNVOTED = 'DOWNVOTED';

export const REQUEST_POST = 'REQUEST_POST';
function requestPost() {
  return {
    type: REQUEST_POST
  }
}

export const RECEIVE_POST = 'RECEIVE_POST';
function receivePost(post) {
  return {
    type: RECEIVE_POST,
    post
  }
}

export function fetchPost(boardId, postId) {
  return function(dispatch) {
    dispatch(requestPost())

    const postsAPI = new Posts(boardId, { postId })
    postsAPI.getOne()
      .then(response => {
        dispatch(receivePost(response.post));
      })
  }
}
