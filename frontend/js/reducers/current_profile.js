import Constants from '../Constants';

export default function reducer(profile = null, action = {}) {
  switch(action.type) {
    case Constants.CURRENT_USER_FETCHED:
      return action.user.profile;

    case Constants.CURRENT_PROFILE_FETCHED:
      return action.profile;

    case Constants.CURRENT_USER_RESET:
      return null;

    default:
      return profile;
  }
}
