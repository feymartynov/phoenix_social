import Constants from '../constants';
import {httpGet, handleFetchError} from '../utils';

const Actions = {
  fetchFeed: (offset = 0, limit = 20) => {
    return dispatch => {
      return httpGet(`/api/v1/feed?offset=${offset}&limit=${limit}`)
        .then(json => {
          if (json.posts.length === 0) return;

          dispatch({
            type: Constants.FEED_FETCHED,
            posts: json.posts
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  connectToChannel: (socket) => {
    return dispatch => {
      const channel = socket.channel('feed');

      channel.on('post:added', json => {
        return dispatch({
          type: Constants.FEED_POST_ADDED,
          post: json.post
        });
      });

      channel.on('post:edited', json => {
        return dispatch({
          type: Constants.FEED_POST_EDITED,
          post: json.post
        });
      });

      channel.on('post:deleted', json => {
        return dispatch({
          type: Constants.FEED_POST_DELETED,
          id: json.id
        });
      });

      channel.join().receive('ok', () => {
        return dispatch({
          type: Constants.FEED_CONNECTED_TO_CHANNEL,
          channel: channel
        });
      });
    };
  },
  reset: channel => {
    return dispatch => {
      channel.leave();
      return dispatch({type: Constants.FEED_RESET});
    };
  }
};

export default Actions;
