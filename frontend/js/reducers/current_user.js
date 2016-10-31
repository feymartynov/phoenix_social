import _ from 'lodash';
import Immutable from 'immutable';
import Constants from '../Constants';

function buildFriendsMap(friendships) {
  return friendships.reduce((acc, friendship) => {
    return acc.set(friendship.user_id, friendship);
  }, Immutable.Map({}));
}

export default function reducer(user = null, action = {}) {
  switch(action.type) {
    case Constants.CURRENT_USER_FETCHED:
      return {
        ..._.omit(action.user, 'friendships'),
        friends: buildFriendsMap(action.user.friendships)};

    case Constants.CURRENT_USER_RESET:
      return null;

    case Constants.USER_ADDED_TO_FRIENDS:
      return {
        ...user,
        friends: user.friends.set(action.friendship.user_id, action.friendship)
      };

    case Constants.USER_REMOVED_FROM_FRIENDS:
      return {
        ...user,
        friends: user.friends.remove(action.friendship.user_id)
      };

    default:
      return user;
  }
}
