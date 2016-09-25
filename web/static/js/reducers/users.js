import Immutable from 'immutable';
import _ from 'lodash';
import Constants from '../constants';

export default function reducer(users = Immutable.Map({}), action = {}) {
  switch (action.type) {
    case Constants.USER_FETCHED:
      const user = _.omit(action.user, 'friendships');

      const friends =
        action.user.friendships
          .map(friend => _.omit(friend, 'state'));

      return friends.concat(user).reduce((acc, u) => acc.set(u.id, u), users);

    case Constants.USER_FETCH_FAILURE:
      return users.delete(action.user.id);

    case Constants.USER_SIGNED_OUT:
      return users.set(action.user.id, action.user.delete('current'));

    default:
      return users;
  }
}
