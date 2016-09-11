import Constants from '../constants';

const initialState = {
  currentUser: null,
  signInError: null,
  signUpErrors: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.FETCH_CURRENT_USER:
      return {...state, currentUser: action.user};

    case Constants.SIGN_IN_ERROR:
      return {...state, signInError: action.error};

    case Constants.SIGN_UP_ERRORS:
      return {...state, signUpErrors: action.errors};

    case Constants.USER_SIGNED_OUT:
      return initialState;

    default:
      return state;
  }
}
