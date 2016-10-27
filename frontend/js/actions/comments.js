import Constants from '../constants';
import {httpPost, httpPut, httpDelete, handleFetchError} from '../utils';

const Actions = {
  create: (post, text) => {
    return dispatch => {
      httpPost(`/api/v1/posts/${post.id}/comments`, {comment: {text: text}})
        .then(json => {
          dispatch({
            type: Constants.COMMENT_ADDED,
            comment: json.comment
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  edit: (comment, text) => {
    return dispatch => {
      httpPut(`/api/v1/comments/${comment.id}`, {comment: {text: text}})
        .then(json => {
          dispatch({
            type: Constants.COMMENT_EDITED,
            comment: json.comment
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  delete: (comment) => {
    return dispatch => {
      httpDelete(`/api/v1/comments/${comment.id}`)
        .then(() => {
          dispatch({
            type: Constants.COMMENT_DELETED,
            comment
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
