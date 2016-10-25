import Constants from '../constants';

const Actions = {
  connectToChannel: (socket) => {
    return dispatch => {
      const channel = socket.channel('presence');

      channel.on('presence_state', state => {
        return dispatch({
          type: Constants.PRESENCE_STATE_RECEIVED,
          state
        });
      });

      channel.on("presence_diff", diff => {
        return dispatch({
          type: Constants.PRESENCE_DIFF_RECEIVED,
          diff
        });
      });

      channel.join().receive('ok', () => {
        return dispatch({
          type: Constants.PRESENCE_CHANNEL_CONNECTED,
          channel
        });
      });
    };
  },
  disconnectFromChannel: (channel) => {
    return dispatch => {
      channel.leave();
      dispatch({type: Constants.PRESENCE_CHANNEL_DISCONNECTED});
    };
  }
};

export default Actions;
