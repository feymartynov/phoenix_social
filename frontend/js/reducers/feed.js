import Immutable from 'immutable';
import Constants from '../constants';

const initialState = {
  posts: Immutable.List([]),
  channel: null
};

function addOrSetPost(posts, post, addEnd = 'tail') {
  const idx = posts.findIndex(p => p.id === post.id);

  if (idx !== -1) {
    return posts.set(idx, post);
  } else if (addEnd == 'head') {
    return posts.unshift(post);
  } else {
    return posts.push(post);
  }
}

function deletePost(posts, id) {
  const idx = posts.findIndex(p => p.id === id);

  if (idx !== -1) {
    return posts.delete(idx);
  } else {
    return posts;
  }
}

export default function reducer(feed = initialState, action = {}) {
  switch (action.type) {
    case Constants.FEED_FETCHED:
      return {...feed, posts: action.posts.reduce(addOrSetPost, feed.posts)};

    case Constants.FEED_CONNECTED_TO_CHANNEL:
      return {...feed, channel: action.channel};

    case Constants.FEED_POST_ADDED:
    case Constants.FEED_POST_EDITED:
      return {...feed, posts: addOrSetPost(feed.posts, action.post, 'head')};

    case Constants.FEED_POST_DELETED:
      return {...feed, posts: deletePost(feed.posts, action.id)};

    case Constants.FEED_RESET:
      return initialState;

    default:
      return feed;
  }
}
