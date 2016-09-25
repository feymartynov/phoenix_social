import Immutable from 'immutable';
import _ from 'lodash';
import Constants from '../constants';

// JS is so fucked up that `[1, 2] === [1, 2] => false`
// so there's some wrapping to compare composite keys with lodash's `isEqual`.

class Key {
  constructor(key) {
    this.key = key;
  }

  get userId () { return this.key[0];}
  get friendId () { return this.key[1]; }

  equals(key) {
    return _.isEqual(this.key, typeof(key) === 'object' ? key.key : key);
  }
}

class Registry {
  constructor(map = Immutable.Map({})) {
    this.map = map;
  }

  get(key, notSetValue) {
    return this.map.get(new Key(key), notSetValue);
  }

  set(key, value) {
    return new Registry(this.map.set(new Key(key), value));
  }
}

export default function reducer(friendships = new Registry, action = {}) {
  switch (action.type) {
    case Constants.USER_FETCHED:
      return action.user.friendships.reduce((acc, friendship) => {
        return acc.set([action.user.id, friendship.id], friendship.state);
      }, friendships);

    case Constants.USER_ADDED_TO_FRIENDS:
    case Constants.USER_REMOVED_FROM_FRIENDS:
      const friendship = action.friendship;
      const {back_friendship} = friendship;

      return friendships
        .set([back_friendship.id, friendship.id], friendship.state)
        .set([friendship.id, back_friendship.id], back_friendship.state);

    default:
      return friendships;
  }
}
