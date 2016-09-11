import {IndexRoute, Route} from 'react-router';
import React from 'react';
import Constants from '../constants';
import MainLayout from '../layouts/main';
import SignIn from '../components/sign_in';
import SignUp from '../components/sign_up';
import Authenticated from '../containers/authenticated';
import AuthenticatedIndex from '../components/authenticated_index';
import SessionActions from '../actions/session';
import Profile from '../components/profile';

export default function configRoutes(store) {
  const ensureAuthenticated = (_nextState, replace, callback) => {
    const currentUser = store.getState().session.currentUser;
    const token = localStorage.getItem(Constants.AUTH_TOKEN_KEY);

    if (!currentUser && token) {
      store.dispatch(SessionActions.fetchCurrentUser());
    } else if (!token) {
      replace('/sign_in');
    }

    callback();
  };

  return (
    <Route component={MainLayout}>
      <Route path="/sign_in" component={SignIn}/>
      <Route path="/sign_up" component={SignUp}/>

      <Route path="/" component={Authenticated} onEnter={ensureAuthenticated}>
        <IndexRoute component={AuthenticatedIndex} />
        <Route path="/user:id" component={Profile} />
      </Route>
    </Route>
  );
}
