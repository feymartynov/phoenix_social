import {Presence} from '../phoenix';
import Constants from '../constants';

const initialState = {
  channel: null,
  presences: {}
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.PRESENCE_CHANNEL_CONNECTED:
      return {...state, channel: action.channel};

    case Constants.PRESENCE_CHANNEL_DISCONNECTED:
      return initialState;

    case Constants.PRESENCE_STATE_RECEIVED:
      return {
        ...state,
        presences: Presence.syncState(state.presences, action.state)
      };

    case Constants.PRESENCE_DIFF_RECEIVED:
      return {
        ...state,
        presences: Presence.syncDiff(state.presences, action.diff)
      };

    default:
      return state;
  }
}
