import Constants from '../constants';
import {httpGet, handleFetchError} from '../utils';
import {setChannelEvents as setPostEvents} from './posts';
import {setChannelEvents as setCommentEvents} from './comments';

const Actions = {
  fetch: (offset = 0, limit = 20) => {
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

      setPostEvents(channel, dispatch);
      setCommentEvents(channel, dispatch);

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
