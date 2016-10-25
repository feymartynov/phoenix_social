import {combineReducers} from 'redux';
import {routerReducer} from 'react-router-redux';
import socket from './socket';
import presence from './presence';
import error from './error';
import signUp from './sign_up';
import users from './users';
import walls from './walls';
import feed from './feed';

export default combineReducers({
  routing: routerReducer,
  socket,
  error,
  presence,
  signUp,
  users,
  walls,
  feed
});
