import _ from 'lodash';
import Immutable from 'immutable';
import Constants from '../Constants';

function buildFriendsMap(friendships) {
  return friendships.reduce((acc, friendship) => {
    return acc.set(friendship.user_id, friendship);
  }, Immutable.Map({}));
}

function updateFriends(profile, action, callback) {
  if (profile.user_id === action.friendship.back_friendship.user_id) {
    return {...profile, friends: callback(profile.friends)};
  } else {
    return profile;
  }
}

export default function reducer(profile = null, action = {}) {
  switch(action.type) {
    case Constants.PROFILE_FETCHED:
      return {
        ..._.omit(action.profile, 'friendships'),
        friends: buildFriendsMap(action.profile.friendships)
      };

    case Constants.PROFILE_RESET:
      return null;

    case Constants.USER_ADDED_TO_FRIENDS:
      return updateFriends(profile, action, friends =>
        friends.set(action.friendship.user_id, action.friendship)
      );

    case Constants.USER_REMOVED_FROM_FRIENDS:
      return updateFriends(profile, action, friends =>
        friends.remove(action.friendship.user_id)
      );

    default:
      return profile;
  }
}
