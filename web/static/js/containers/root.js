import React, {PropTypes} from 'react';
import {Provider} from 'react-redux';
import {Router, RoutingContext} from 'react-router';
import configRoutes from '../routes';
import ErrorActions from '../actions/error';

const propTypes = {
  routerHistory: PropTypes.object.isRequired,
  store: PropTypes.object.isRequired
};

const Root = ({routerHistory, store}) => {
  function onRouterUpdate() {
    store.dispatch(ErrorActions.dismiss());
  }

  return (
    <Provider store={store}>
      <Router history={routerHistory} onUpdate={onRouterUpdate}>
        {configRoutes(store)}
      </Router>
    </Provider>
  );
};

Root.propTypes = propTypes;
export default Root;
