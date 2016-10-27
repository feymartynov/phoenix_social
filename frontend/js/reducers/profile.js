import _ from 'lodash';
import Immutable from 'immutable';
import Constants from '../Constants';

function buildFriendsMap(friendships) {
  return friendships.reduce((acc, friendship) => {
    return acc.set(friendship.id, friendship);
  }, Immutable.Map({}));
}

function updateFriends(user, action, callback) {
  if (user.id === action.friendship.back_friendship.id) {
    return {...user, friends: callback(user.friends)};
  } else {
    return user;
  }
}

export default function reducer(user = null, action = {}) {
  switch(action.type) {
    case Constants.PROFILE_FETCHED:
      return {
        ..._.omit(action.user, 'friendships'),
        friends: buildFriendsMap(action.user.friendships)};

    case Constants.PROFILE_RESET:
      return null;

    case Constants.USER_ADDED_TO_FRIENDS:
      return updateFriends(user, action, friends =>
        friends.set(action.friendship.id, action.friendship)
      );

    case Constants.USER_REMOVED_FROM_FRIENDS:
      return updateFriends(user, action, friends =>
        friends.remove(action.friendship.id)
      );

    default:
      return user;
  }
}
