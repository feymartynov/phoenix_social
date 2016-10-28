import Constants from '../constants';
import {httpPost, httpPut, httpDelete, handleFetchError} from '../utils';

export function setChannelEvents(channel, dispatch) {
  channel.on('comment:added', json => {
    return dispatch({
      type: Constants.COMMENT_ADDED,
      comment: json.comment
    });
  });

  channel.on('comment:edited', json => {
    return dispatch({
      type: Constants.COMMENT_EDITED,
      comment: json.comment
    });
  });

  channel.on('comment:deleted', json => {
    return dispatch({
      type: Constants.COMMENT_DELETED,
      comment: json.comment
    });
  });
}

const Actions = {
  create: (post, text) => {
    return dispatch => {
      httpPost(`/api/v1/posts/${post.id}/comments`, {comment: {text: text}})
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  edit: (comment, text) => {
    return dispatch => {
      httpPut(`/api/v1/comments/${comment.id}`, {comment: {text: text}})
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  delete: (comment) => {
    return dispatch => {
      httpDelete(`/api/v1/comments/${comment.id}`)
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
