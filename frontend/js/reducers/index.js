import {combineReducers} from 'redux';
import {routerReducer} from 'react-router-redux';
import error from './error';
import signUp from './sign_up';
import users from './users';
import walls from './walls';
import feed from './feed';

export default combineReducers({
  routing: routerReducer,
  error,
  signUp,
  users,
  walls,
  feed
});
