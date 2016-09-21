import Constants from '../constants';

const initialState = {
  user: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.USER_FETCHED:
      return {...state, user: action.user};

    case Constants.USER_FETCH_FAILURE:
      return initialState;

    default:
      return state;
  }
}
