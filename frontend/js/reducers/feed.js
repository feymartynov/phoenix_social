import Immutable from 'immutable';
import Constants from '../constants';

const initialState = {
  posts: Immutable.List([]),
  channel: null,
  fetched: false
};

function wrap(post) {
  return {...post, comments: Immutable.List(post.comments)};
}

function addOrSetPost(posts, post, addEnd = 'tail') {
  const idx = posts.findIndex(p => p.id === post.id);

  if (idx !== -1) {
    return posts.set(idx, wrap(post));
  } else if (addEnd == 'head') {
    return posts.unshift(wrap(post));
  } else {
    return posts.push(wrap(post));
  }
}

function setPosts(feed, posts) {
  if (posts.length === 0) {
    return feed.posts;
  } else {
    return posts.reduce(addOrSetPost, feed.posts)
  }
}

function deletePost(posts, id) {
  const idx = posts.findIndex(p => p.id === id);
  return posts.delete(idx);
}

function updateComments(feed, postId, callback) {
  const idx = feed.posts.findIndex(p => p.id === postId);
  const post = feed.posts.get(idx);
  const updatedComments = callback(post.comments);
  const updatedPost = {...post, comments: updatedComments};
  return {...feed, posts: feed.posts.set(idx, updatedPost)};
}

export default function reducer(feed = initialState, action = {}) {
  switch (action.type) {
    case Constants.FEED_FETCHED:
      return {...feed, posts: setPosts(feed, action.posts), fetched: true};

    case Constants.FEED_CONNECTED_TO_CHANNEL:
      return {...feed, channel: action.channel};

    case Constants.FEED_RESET:
      return initialState;
  }

  if (!feed.fetched) return feed;

  switch(action.type) {
    case Constants.POST_ADDED:
    case Constants.POST_EDITED:
      return {...feed, posts: addOrSetPost(feed.posts, action.post, 'head')};

    case Constants.POST_DELETED:
      return {...feed, posts: deletePost(feed.posts, action.post.id)};

    case Constants.COMMENT_ADDED:
      return updateComments(feed, action.comment.post_id, comments =>
        comments.push(action.comment)
      );

    case Constants.COMMENT_EDITED:
      return updateComments(feed, action.comment.post_id, comments =>
        comments.set(
          comments.findIndex(c => c.id === action.comment.id),
          action.comment)
      );

    case Constants.COMMENT_DELETED:
      return updateComments(feed, action.comment.post_id, comments =>
        comments.remove(comments.findIndex(c => c.id === action.comment.id))
      );

    default:
      return feed;
  }
}
