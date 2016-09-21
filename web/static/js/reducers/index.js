import {combineReducers} from 'redux';
import {routerReducer} from 'react-router-redux';
import error from './error';
import session from './session';
import profile from './profile';

export default combineReducers({
  routing: routerReducer,
  error,
  session,
  profile
});
