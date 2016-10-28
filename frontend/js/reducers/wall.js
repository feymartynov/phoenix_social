import Immutable from 'immutable';
import Constants from '../constants';

const initialState = {
  posts: Immutable.List([]),
  fetched: false,
  channel: null
};

function wrap(post) {
  return {...post, comments: Immutable.List(post.comments)};
}

function setPosts(wall, posts) {
  if (posts.length === 0) {
    return wall.posts;
  } else {
    return wall.posts.concat(posts.map(wrap));
  }
}

function findIndex(items, id) {
  return items.findIndex(item => item.id === id);
}

function updatePost(wall, id, callback) {
  const idx = findIndex(wall.posts, id);

  if (idx === -1) {
    return wall;
  } else {
    return {
      ...wall,
      posts: wall.posts.set(idx, callback(wall.posts.get(idx)))
    };
  }
}

function updateComments(wall, postId, callback) {
  return updatePost(wall, postId, post => (
    {...post, comments: callback(post.comments)}
  ));
}

export default function reducer(wall = initialState, action = {}) {
  switch (action.type) {
    case Constants.WALL_RESET:
      return initialState;

    case Constants.WALL_CONNECTED_TO_CHANNEL:
      return {...wall, channel: action.channel};

    case Constants.WALL_FETCHED:
      return {...wall, posts: setPosts(wall, action.posts), fetched: true};
  }

  if (!wall.fetched) return wall;

  switch (action.type) {
    case Constants.POST_ADDED:
      return {...wall, posts: wall.posts.unshift(wrap(action.post))};

    case Constants.POST_EDITED:
      return updatePost(wall, action.post.id, () => action.post);

    case Constants.POST_DELETED:
      return {
        ...wall,
        posts: wall.posts.remove(findIndex(wall.posts, action.post.id))
      };

    case Constants.COMMENT_ADDED:
      return updateComments(wall, action.comment.post_id, comments =>
        comments.push(action.comment)
      );

    case Constants.COMMENT_EDITED:
      return updateComments(wall, action.comment.post_id, comments =>
        comments.set(
          findIndex(comments, action.comment.id),
          action.comment)
      );

    case Constants.COMMENT_DELETED:
      return updateComments(wall, action.comment.post_id, comments =>
        comments.remove(findIndex(comments, action.comment.id))
      );

    default:
      return wall;
  }
}
