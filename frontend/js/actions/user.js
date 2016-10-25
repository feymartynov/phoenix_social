import Constants from '../constants';
import {httpGet, httpPost, httpPut, httpDelete, httpFetch, handleFetchError} from '../utils';
import ErrorActions from './error';

const Actions = {
  fetchUser: (id) => {
    return dispatch => {
      return httpGet(`/api/v1/users/${id}`)
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
              dispatch({
                type: Constants.USER_FETCH_FAILURE,
                id
              });

              dispatch(ErrorActions.raise(json.error));
            });
        });
    };
  },
  addToFriends: (user) => {
    return dispatch => {
      return httpPost('/api/v1/friends', {user_id: user.id})
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
      return httpDelete(`/api/v1/friends/${user.id}`)
        .then(json => {
          dispatch({
            type: Constants.USER_REMOVED_FROM_FRIENDS,
            friendship: json.friendship,
            back_friendship: json.back_friendship
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  uploadAvatar: (file) => {
    return dispatch => {
      let body = new FormData();
      body.append('avatar', file);

      return httpFetch('/api/v1/avatar', {method: 'post', headers: {}, body: body})
        .then(json => {
          dispatch({
            type: Constants.USER_FETCHED,
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
            type: Constants.USER_FETCHED,
            user: json.user
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  updateProfile: (changeset) => {
    return dispatch => {
      return httpPut(`/api/v1/users/current`, {user: changeset})
        .then(json => {
          dispatch({
            type: Constants.USER_FETCHED,
            current: true,
            user: json.user
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
