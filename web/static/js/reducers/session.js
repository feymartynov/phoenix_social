import {combineReducers} from 'redux';
import Constants from '../constants';
import {reduceReducers} from '../utils';
import currentUser from './session/current_user';

const initialState = {
  currentUser: null,
  signUpErrors: null
};

function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.FETCH_CURRENT_USER:
      return {...state, currentUser: action.user};

    case Constants.SIGN_UP_FAILURE:
      return {...state, signUpErrors: action.errors};

    case Constants.USER_SIGNED_OUT:
      return initialState;

    default:
      return state;
  }
}

export default reduceReducers(combineReducers({currentUser}), reducer);
