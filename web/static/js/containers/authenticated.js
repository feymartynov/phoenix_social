import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import Header from '../components/shared/header';
import Error from '../components/shared/error';

class Authenticated extends React.Component {
  render() {
    if (!this.props.currentUser) return false;

    return (
      <div>
        <Header />
        <div className="container">
          <aside className="col-md-2">
            <nav className="list-group">
              <Link
                to={`/user${this.props.currentUser.id}`}
                className="list-group-item">

                My profile
              </Link>

              <Link
                to='/friends'
                className="list-group-item">

                My friends
              </Link>
            </nav>
          </aside>
          <main className="col-md-10">
            <Error />
            {this.props.children}
          </main>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.session.currentUser
});

export default connect(mapStateToProps)(Authenticated);
