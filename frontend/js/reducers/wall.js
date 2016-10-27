import Immutable from 'immutable';
import Constants from '../constants';

function wrap(post) {
  return {...post, comments: Immutable.List(post.comments)};
}

function findIndex(items, id) {
  return items.findIndex(item => item.id === id);
}

function updatePost(posts, id, callback) {
  const idx = findIndex(posts, id);

  if (idx === -1) {
    return posts;
  } else {
    return posts.set(idx, callback(posts.get(idx)));
  }
}

function updateComments(posts, postId, callback) {
  return updatePost(posts, postId, post => (
    {...post, comments: callback(post.comments)}
  ));
}

export default function reducer(posts = Immutable.List([]), action = {}) {
  switch (action.type) {
    case Constants.WALL_RESET:
      return Immutable.List([]);

    case Constants.WALL_FETCHED:
      return posts.concat(action.posts.map(wrap));

    case Constants.POST_CREATED:
      return posts.unshift(wrap(action.post));

    case Constants.POST_UPDATED:
      return updatePost(posts, action.post.id, () => action.post);

    case Constants.POST_DELETED:
      return posts.remove(findIndex(posts, action.post.id));

    case Constants.COMMENT_CREATED:
      return updateComments(posts, action.comment.post_id, comments =>
        comments.push(action.comment)
      );

    case Constants.COMMENT_UPDATED:
      return updateComments(posts, action.comment.post_id, comments =>
        comments.set(
          findIndex(comments, action.comment.id),
          action.comment)
      );

    case Constants.COMMENT_DELETED:
      return updateComments(posts, action.comment.post_id, comments =>
        comments.remove(findIndex(comments, action.comment.id))
      );

    default:
      return posts;
  }
}
