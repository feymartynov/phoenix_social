import Constants from '../constants';

const initialState = {
  user: null,
  error: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.USER_FETCHED:
      return {...state, user: action.user, error: null};

    case Constants.USER_FETCH_FAILURE:
      return {...state, user: null, error: action.error};

    case Constants.USER_ADD_TO_FRIENDS_FAILURE:
      return {...state, error: action.error};

    case Constants.USER_REMOVE_FROM_FRIENDS_FAILURE:
      return {...state, error: action.error};

    default:
      return state;
  }
}
