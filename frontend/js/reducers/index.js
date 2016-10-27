import {combineReducers} from 'redux';
import {routerReducer} from 'react-router-redux';
import socket from './socket';
import presence from './presence';
import error from './error';
import signUp from './sign_up';
import currentUser from './current_user';
import profile from './profile';
import wall from './wall';
import feed from './feed';

export default combineReducers({
  routing: routerReducer,
  socket,
  error,
  presence,
  signUp,
  currentUser,
  profile,
  wall,
  feed
});
