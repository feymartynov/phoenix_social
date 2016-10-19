import Constants from '../constants';
import {httpGet, httpPost, httpPut, httpDelete, handleFetchError} from '../utils';

const Actions = {
  fetchWall: (user, offset = 0, limit = 10) => {
    return dispatch => {
      const params = `offset=${offset}&limit=${limit}`;

      httpGet(`/api/v1/users/${user.id}/posts?${params}`)
        .then(json => {
          if (json.posts.length === 0) return;

          dispatch({
            type: Constants.WALL_FETCHED,
            user: user,
            posts: json.posts
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  createPost: (text) => {
    return dispatch => {
      httpPost('/api/v1/posts', {post: {text: text}})
        .then(json => {
          dispatch({
            type: Constants.POST_CREATED,
            post: json.post
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  editPost: (post, text) => {
    return dispatch => {
      httpPut(`/api/v1/posts/${post.id}`, {post: {text: text}})
        .then(json => {
          dispatch({
            type: Constants.POST_UPDATED,
            post: json.post
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  deletePost: (post) => {
    return dispatch => {
      httpDelete(`/api/v1/posts/${post.id}`)
        .then(() => {
          dispatch({
            type: Constants.POST_DELETED,
            post: post
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
