import Posts from 'API/Posts';

export const UPVOTED = 'UPVOTED';
export const DOWNVOTED = 'DOWNVOTED';

export const REQUEST_POST = 'REQUEST_POST';
function requestPost() {
  return {
    type: REQUEST_POST
  }
}

export const REQUEST_POSTS = 'REQUEST_POSTS';
function requestPosts() {
  return {
    type: REQUEST_POSTS
  }
}

export const RECEIVE_POST = 'RECEIVE_POST';
function receivePost(post) {
  return {
    type: RECEIVE_POST,
    post
  }
}

export const FETCH_POSTS_FAILED = 'FETCH_POSTS_FAILED';
function fetchPostsFailed(status) {
  return {
    type: FETCH_POSTS_FAILED
  }
}

export const RECEIVE_POSTS = 'RECEIVE_POSTS';
function receivePosts(posts) {
  return {
    type: RECEIVE_POSTS,
    posts
  }
}

export function fetchPost(boardId, postId) {
  return function(dispatch) {
    dispatch(requestPost());

    const postsApi = new Posts(boardId, { postId });
    postsApi.getOne()
      .then(response => {
        dispatch(receivePost(response.post));
      });
  }
}

export function fetchPosts(boardId, params = {}) {
  return function(dispatch) {
    dispatch(requestPosts());

    const postsApi = new Posts(boardId);
    postsApi.getMany(params)
      .then(response => {
        dispatch(receivePosts(response.posts));
      })
      .catch(response => {
        dispatch(fetchPostsFailed(response.status));
      })
  }
}
