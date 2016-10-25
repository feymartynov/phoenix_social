import {Socket} from '../phoenix';
import Constants from '../constants';

const Actions = {
  connect: () => {
    return dispatch => {
      const token = localStorage.getItem(Constants.AUTH_TOKEN_KEY);
      const socket = new Socket('/socket', {params: {token}});

      socket.connect();

      return dispatch({
        type: Constants.SOCKET_CONNECTED,
        socket
      });
    };
  }
};

export default Actions;
