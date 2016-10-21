import Constants from '../constants';

export default function reducer(error = null, action = {}) {
  switch (action.type) {
    case Constants.ERROR_RAISED:
      return action.error;

    case Constants.ERROR_DISMISSED:
      return null;

    default:
      return error;
  }
}
