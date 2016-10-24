import Constants from '../constants';

export default function reducer(socket = null, action = {}) {
  switch (action.type) {
    case Constants.SOCKET_CONNECTED:
      return action.socket;

    default:
      return socket;
  }
}
