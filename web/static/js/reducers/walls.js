import Immutable from 'immutable';
import Constants from '../constants';

export default function reducer(walls = Immutable.Map({}), action = {}) {
  switch (action.type) {
    case Constants.WALL_FETCHED:
      return walls.set(action.user.id, Immutable.List(action.posts));

    case Constants.POST_CREATED:
      const userId = action.post.user_id;
      const wall = walls.get(userId).unshift(action.post);
      return walls.set(userId, wall);

    default:
      return walls;
  }
}
