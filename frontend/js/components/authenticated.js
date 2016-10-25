import React from 'react';
import {connect} from 'react-redux';
import Loader from './shared/loader';
import Header from './header';
import Sidebar from './sidebar';
import Error from './shared/error';
import Socket from './socket';
import Presence from './presence';
import SessionActions from '../actions/session';

class Authenticated extends React.Component {
  _renderLayout() {
    return (
      <div>
        <Socket>
          <Presence/>
          <Header />
          <div className="container">
            <Sidebar />
            <main className="col-md-10">
              <Error />
              {this.props.children}
            </main>
          </div>
        </Socket>
      </div>
    );
  }

  render() {
    return (
      <Loader
        action={SessionActions.fetchCurrentUser()}
        onLoaded={::this._renderLayout}
        loaded={this.props.currentUser}
        error={this.props.error}/>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.users.getCurrentUser(),
  error: state.error,
  presence: state.presence
});

export default connect(mapStateToProps)(Authenticated);
