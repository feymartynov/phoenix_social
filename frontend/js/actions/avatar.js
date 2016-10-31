import Constants from '../constants';
import {httpDelete, httpFetch, handleFetchError} from '../utils';

const Actions = {
  uploadAvatar: (profile, file) => {
    return dispatch => {
      const url = `/api/v1/profiles/${profile.id}/avatar`;
      let body = new FormData();
      body.append('avatar', file);

      return httpFetch(url, {method: 'post', headers: {}, body: body})
        .then(json => {
          dispatch({
            type: Constants.CURRENT_USER_FETCHED,
            user: json.user
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  removeAvatar: (profile) => {
    return dispatch => {
      return httpDelete(`/api/v1/profiles/${profile.id}/avatar`)
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
