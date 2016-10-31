import Constants from '../constants';
import {httpPost, httpDelete, handleFetchError} from '../utils';

const Actions = {
  addToFriends: (profile) => {
    return dispatch => {
      return httpPost('/api/v1/friends', {user_id: profile.user_id})
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
  removeFromFriends: (profile) => {
    return dispatch => {
      return httpDelete(`/api/v1/friends/${profile.user_id}`)
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
