import Constants from '../constants';
import {httpDelete, httpFetch, handleFetchError} from '../utils';

const Actions = {
  uploadAvatar: (file) => {
    return dispatch => {
      let body = new FormData();
      body.append('avatar', file);

      return httpFetch('/api/v1/avatar', {method: 'post', headers: {}, body: body})
        .then(json => {
          dispatch({
            type: Constants.CURRENT_USER_FETCHED,
            user: json.user
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  removeAvatar: () => {
    return dispatch => {
      return httpDelete('/api/v1/avatar')
        .then(json => {
          dispatch({
            type: Constants.CURRENT_USER_FETCHED,
            user: json.user
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
