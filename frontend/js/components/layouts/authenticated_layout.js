import React from 'react';
import {connect} from 'react-redux';
import Loader from '../shared/loader';
import Header from './authenticated_layout/header';
import Sidebar from './authenticated_layout/sidebar';
import Error from '../shared/error';
import Socket from '../aux/socket';
import Presence from '../aux/presence';
import CurrentUserActions from '../../actions/current_user';

class AuthenticatedLayout extends React.Component {
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
        action={CurrentUserActions.fetch()}
        onLoaded={::this._renderLayout}
        loaded={this.props.currentUser}
        error={this.props.error}/>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.currentUser,
  error: state.error,
  presence: state.presence
});

export default connect(mapStateToProps)(AuthenticatedLayout);
