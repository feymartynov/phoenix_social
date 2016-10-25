import {IndexRoute, Route} from 'react-router';
import React from 'react';
import Constants from './constants';
import MainLayout from './components/layouts/main_layout';
import NotFound from './components/pages/not_found';
import SignIn from './components/pages/sign_in';
import SignUp from './components/pages/sign_up';
import AuthenticatedLayout from './components/layouts/authenticated_layout';
import AuthenticatedIndexRedirect from './components/aux/authenticated_index_redirect';
import Profile from './components/pages/profile';
import Friends from './components/pages/friends';
import Feed from './components/pages/feed';

export default function configRoutes(_store) {
  function ensureAuthenticated(_nextState, replace, callback) {
    const token = localStorage.getItem(Constants.AUTH_TOKEN_KEY);
    if (!token) replace('/sign_in');
    callback();
  }

  return (
    <Route component={MainLayout}>
      <Route path="/sign_in" component={SignIn}/>
      <Route path="/sign_up" component={SignUp}/>

      <Route path="/" component={AuthenticatedLayout} onEnter={ensureAuthenticated}>
        <IndexRoute component={AuthenticatedIndexRedirect}/>

        <Route path="user:userId">
          <IndexRoute component={Profile}/>
          <Route path="friends" component={Friends}/>
        </Route>

        <Route path="feed" component={Feed}/>
        <Route path="*" component={NotFound}/>
      </Route>
    </Route>
  );
}
