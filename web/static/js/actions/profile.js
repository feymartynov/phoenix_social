import Constants from '../constants';
import {httpGet, httpPost, httpDelete, handleFetchError} from '../utils';
import ErrorActions from './error';

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
          if (!error.response) throw error;

          error.response.json()
            .then(json => {
              dispatch({type: Constants.USER_FETCH_FAILURE});
              dispatch(ErrorActions.raise(json.error));
            })
            .catch(error => console.error(error));
        });
    };
  },
  addToFriends: (user) => {
    return dispatch => {
      httpPost('/api/v1/friends', {user_id: user.id})
        .then(json => {
          dispatch({
            type: Constants.USER_ADDED_TO_FRIENDS,
            friendship: json.friendship,
            back_friendship: json.back_friendship
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  removeFromFriends: (user) => {
    return dispatch => {
      httpDelete(`/api/v1/friends/${user.id}`)
        .then(json => {
          dispatch({
            type: Constants.USER_REMOVED_FROM_FRIENDS,
            friendship: json.friendship,
            back_friendship: json.back_friendship
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
