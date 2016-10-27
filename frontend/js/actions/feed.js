import Constants from '../constants';
import {httpGet, handleFetchError} from '../utils';

const Actions = {
  fetchFeed: (offset = 0, limit = 20) => {
    return dispatch => {
      return httpGet(`/api/v1/feed?offset=${offset}&limit=${limit}`)
        .then(json => {
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
          type: Constants.POST_ADDED,
          post: json.post
        });
      });

      channel.on('post:edited', json => {
        return dispatch({
          type: Constants.POST_EDITED,
          post: json.post
        });
      });

      channel.on('post:deleted', json => {
        return dispatch({
          type: Constants.POST_DELETED,
          post: json.post
        });
      });

      channel.on('comment:added', json => {
        return dispatch({
          type: Constants.COMMENT_ADDED,
          comment: json.comment
        });
      });

      channel.on('comment:edited', json => {
        return dispatch({
          type: Constants.COMMENT_EDITED,
          comment: json.comment
        });
      });

      channel.on('comment:deleted', json => {
        return dispatch({
          type: Constants.COMMENT_DELETED,
          comment: json.comment
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
