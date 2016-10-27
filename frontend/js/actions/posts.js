import Constants from '../constants';
import {httpGet, httpPost, httpPut, httpDelete, handleFetchError} from '../utils';

const Actions = {
  fetchWall: (user, offset = 0, limit = 10) => {
    return dispatch => {
      const params = `offset=${offset}&limit=${limit}`;

      httpGet(`/api/v1/users/${user.id}/posts?${params}`)
        .then(json => {
          dispatch({
            type: Constants.WALL_FETCHED,
            user: user,
            posts: json.posts
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  resetWall: () => {
    return dispatch => {
      dispatch({type: Constants.WALL_RESET});
    };
  },
  create: (user, text) => {
    return dispatch => {
      httpPost(`/api/v1/users/${user.id}/posts`, {post: {text: text}})
        .then(json => {
          dispatch({
            type: Constants.POST_ADDED,
            post: json.post
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  edit: (post, text) => {
    return dispatch => {
      httpPut(`/api/v1/posts/${post.id}`, {post: {text: text}})
        .then(json => {
          dispatch({
            type: Constants.POST_EDITED,
            post: json.post
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  delete: (post) => {
    return dispatch => {
      httpDelete(`/api/v1/posts/${post.id}`)
        .then(() => {
          dispatch({
            type: Constants.POST_DELETED,
            post
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
