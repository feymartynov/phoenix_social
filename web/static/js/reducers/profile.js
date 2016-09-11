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
    default:
      return state;
  }
}
