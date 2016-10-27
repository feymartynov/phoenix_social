import Constants from '../constants';
import {httpGet} from '../utils';
import ErrorActions from './error';

const Actions = {
  fetch: (id) => {
    return dispatch => {
      return httpGet(`/api/v1/users/${id}`)
        .then(data => {
          dispatch({
            type: Constants.PROFILE_FETCHED,
            user: data.user
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
  }
};

export default Actions;
