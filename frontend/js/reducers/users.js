import Immutable from 'immutable';
import _ from 'lodash';
import Constants from '../constants';

class UsersRegistry {
  constructor(map = Immutable.Map({})) {
    this.map = map;
  }

  _setEntry(entry) {
    return new UsersRegistry(this.map.set(entry.id, entry));
  }

  _buildFriendsMap(friendships) {
    return friendships.reduce((acc, friendship) => {
      return acc.set(friendship.id, friendship);
    }, Immutable.Map({}));
  }

  set(user, isCurrent = null) {
    const entry = {
      ..._.omit(user, 'friendships'),
      friends: this._buildFriendsMap(user.friendships),
      current: isCurrent === null ? user.current : isCurrent
    };

    return this._setEntry(entry);
  }

  setFriendship(friendship) {
    const user = this.getCurrentUser();
    const updatedFriends = user.friends.set(friendship.id, friendship);
    return this._setEntry({...user, friends: updatedFriends});
  }

  delete(id) {
    return new UsersRegistry(this.map.delete(id));
  }

  get(id) {
    return this.map.get(id);
  }

  getCurrentUser() {
    return this.map.find(user => user.current);
  }

  unsetCurrentFlag() {
    return this._setEntry({...this.getCurrentUser(), current: false});
  }
}

export default function reducer(users = new UsersRegistry, action = {}) {
  switch (action.type) {
    case Constants.USER_FETCHED:
      return users.set(action.user, action.current);

    case Constants.USER_FETCH_FAILURE:
      return users.delete(action.id);

    case Constants.USER_SIGNED_OUT:
      return users.unsetCurrentFlag();

    case Constants.USER_ADDED_TO_FRIENDS:
    case Constants.USER_REMOVED_FROM_FRIENDS:
      return users.setFriendship(action.friendship);

    default:
      return users;
  }
}
