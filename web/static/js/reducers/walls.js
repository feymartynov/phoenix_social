import Immutable from 'immutable';
import Constants from '../constants';

class Registry {
  constructor(map = Immutable.Map({})) {
    this.map = map;
  }

  _setWall(userId, posts) {
    return new Registry(this.map.set(userId, posts));
  }

  get(userId) {
    return this.map.get(userId);
  }

  set(userId, posts) {
    return this._setWall(userId, Immutable.List(posts));
  }

  add(post) {
    const wall = this.map.get(post.user_id);
    const updatedWall = wall.unshift(post);
    return this._setWall(post.user_id, updatedWall);
  }

  update(post) {
    const wall = this.map.get(post.user_id);
    const idx = wall.findIndex(p => p.id === post.id);
    const updatedWall = wall.set(idx, post);
    return this._setWall(post.user_id, updatedWall);
  }

  delete(post) {
    const wall = this.map.get(post.user_id);
    const updatedWall = wall.filterNot(p => p.id === post.id);
    return this._setWall(post.user_id, updatedWall);
  }
}

export default function reducer(walls = new Registry, action = {}) {
  switch (action.type) {
    case Constants.WALL_FETCHED:
      return walls.set(action.user.id, action.posts);

    case Constants.POST_CREATED:
      return walls.add(action.post);

    case Constants.POST_UPDATED:
      return walls.update(action.post);

    case Constants.POST_DELETED:
      return walls.delete(action.post);

    default:
      return walls;
  }
}
