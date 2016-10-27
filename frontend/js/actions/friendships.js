import Constants from '../constants';
import {httpPost, httpDelete, handleFetchError} from '../utils';

const Actions = {
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
  }
};

export default Actions;
