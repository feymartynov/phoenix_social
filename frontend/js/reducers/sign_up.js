import Constants from '../constants';

const initialState = {
  errors: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.SIGN_UP_FAILURE:
      return {...state, errors: action.errors};

    default:
      return state;
  }
}
