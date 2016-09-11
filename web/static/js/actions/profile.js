import Constants from '../constants';
import {httpGet} from '../utils';

const Actions = {
  fetchUser: (id) => {
    return dispatch => {
      httpGet(`/api/v1/users/${id}`)
        .then(data => {
          dispatch({
            type: Constants.USER_FETCHED,
            user: data.user
          });
        })
        .catch(error => {
          error.response.json()
          .then(json => {
            dispatch({
              type: Constants.USER_FETCH_FAILURE,
              id: id,
              error: json.error
            });
          });
        });
    };
  }
};

export default Actions;
