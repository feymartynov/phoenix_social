import Constants from '../constants';

export default function reducer(feed = {posts: []}, action = {}) {
  switch (action.type) {
    case Constants.FEED_FETCHED:
      return {posts: feed.posts.concat(action.posts)};

    default:
      return feed;
  }
}
