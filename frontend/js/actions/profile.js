import Constants from '../constants';
import {httpGet, httpPut, handleFetchError} from '../utils';
import ErrorActions from './error';

const Actions = {
  fetch: (id) => {
    return dispatch => {
      return httpGet(`/api/v1/profiles/${id}`)
        .then(data => {
          dispatch({
            type: Constants.PROFILE_FETCHED,
            profile: data.profile
          });
        })
        .catch(error => {
          if (!error.response) throw error;

          error.response.json()
            .then(json => {
              dispatch({type: Constants.PROFILE_RESET});
              dispatch(ErrorActions.raise(json.error));
            });
        });
    };
  },
  update: (profile, changeset) => {
    return dispatch => {
      return httpPut(`/api/v1/profiles/${profile.id}`, {profile: changeset})
        .then(json => {
          dispatch({
            type: Constants.CURRENT_PROFILE_FETCHED,
            profile: json.profile
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
