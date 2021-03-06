import Constants from '../constants';
import {httpGet, handleFetchError} from '../utils';
import {setChannelEvents as setPostEvents} from './posts';
import {setChannelEvents as setCommentEvents} from './comments';

const Actions = {
  fetch: (user, offset = 0, limit = 10) => {
    return dispatch => {
      const params = `offset=${offset}&limit=${limit}`;

      httpGet(`/api/v1/users/${user.id}/posts?${params}`)
        .then(json => {
          dispatch({
            type: Constants.WALL_FETCHED,
            user: user,
            posts: json.posts
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  connectToChannel: (socket, user) => {
    return dispatch => {
      const channel = socket.channel(`wall:${user.id}`);

      setPostEvents(channel, dispatch);
      setCommentEvents(channel, dispatch);

      channel.join().receive('ok', () => {
        return dispatch({
          type: Constants.WALL_CONNECTED_TO_CHANNEL,
          channel: channel
        });
      });
    };
  },
  reset: (channel) => {
    return dispatch => {
      channel.leave();
      dispatch({type: Constants.WALL_RESET});
    };
  },
};

export default Actions;
