import Constants from '../constants';
import {httpPost, httpPut, httpDelete, handleFetchError} from '../utils';

export function setChannelEvents(channel, dispatch) {
  channel.on('post:added', json => {
    return dispatch({
      type: Constants.POST_ADDED,
      post: json.post
    });
  });

  channel.on('post:edited', json => {
    return dispatch({
      type: Constants.POST_EDITED,
      post: json.post
    });
  });

  channel.on('post:deleted', json => {
    return dispatch({
      type: Constants.POST_DELETED,
      post: json.post
    });
  });
}

const Actions = {
  create: (user, text) => {
    return dispatch => {
      httpPost(`/api/v1/users/${user.id}/posts`, {post: {text: text}})
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  edit: (post, text) => {
    return dispatch => {
      httpPut(`/api/v1/posts/${post.id}`, {post: {text: text}})
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  delete: (post) => {
    return dispatch => {
      httpDelete(`/api/v1/posts/${post.id}`)
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
