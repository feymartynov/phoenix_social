import Constants from '../constants';
import {httpGet, httpPost, httpDelete} from '../utils';

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
                id,
                error: json.error
              });
            });
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
        .catch(error => {
          error.response.json()
            .then(json => {
              dispatch({
                type: Constants.USER_ADD_TO_FRIENDS_FAILURE,
                error: json.error
              });
            });
        });
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
        .catch(error => {
          error.response.json()
            .then(json => {
              dispatch({
                type: Constants.USER_REMOVE_FROM_FRIENDS_FAILURE,
                error: json
              });
            });
        });
    };
  }
};

export default Actions;
