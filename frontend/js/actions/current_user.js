import Constants from '../constants';
import {httpGet, httpPut, handleFetchError} from '../utils';
import ErrorActions from './error';

const Actions = {
  fetch: () => {
    return dispatch => {
      return httpGet(`/api/v1/users/current`)
        .then(data => {
          dispatch({
            type: Constants.CURRENT_USER_FETCHED,
            user: data.user
          });
        })
        .catch(error => {
          if (!error.response) throw error;

          error.response.json()
            .then(json => {
              dispatch({type: Constants.CURRENT_USER_RESET});
              dispatch(ErrorActions.raise(json.error));
            });
        });
    };
  },
  update: (changeset) => {
    return dispatch => {
      return httpPut(`/api/v1/users/current`, {user: changeset})
        .then(json => {
          dispatch({
            type: Constants.CURRENT_USER_FETCHED,
            current: true,
            user: json.user
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
