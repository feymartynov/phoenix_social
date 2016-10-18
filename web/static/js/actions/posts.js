import Constants from '../constants';
import {httpGet, httpPost, handleFetchError} from '../utils';

const Actions = {
  fetchWall: (user, offset = 0, limit = 100) => {
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
  }
};

export default Actions;
