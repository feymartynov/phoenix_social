import Constants from '../constants';
import {httpGet, handleFetchError} from '../utils';

const Actions = {
  fetchFeed: (offset = 0, limit = 20) => {
    return dispatch => {
      httpGet(`/api/v1/feed?offset=${offset}&limit=${limit}`)
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
      const channel = socket.channel(`feed`);

      channel.on('post:added', json => {
        dispatch({
          type: Constants.FEED_POST_ADDED,
          post: json.post
        });
      });

      channel.on('post:edited', json => {
        dispatch({
          type: Constants.FEED_POST_EDITED,
          post: json.post
        });
      });

      channel.on('post:deleted', json => {
        dispatch({
          type: Constants.FEED_POST_DELETED,
          id: json.id
        });
      });

      channel.join().receive('ok', () => {
        dispatch({
          type: Constants.FEED_CONNECTED_TO_CHANNEL,
          channel: channel
        });
      });
    };
  },
  reset: channel => {
    return dispatch => {
      channel.leave();
      dispatch({type: Constants.FEED_RESET});
    };
  }
};

export default Actions;
