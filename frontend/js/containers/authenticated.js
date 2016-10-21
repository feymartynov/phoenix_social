import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import Header from '../components/shared/header';
import Error from '../components/shared/error';

class Authenticated extends React.Component {
  render() {
    if (!this.props.currentUser) return false;
    const userSlug = `user${this.props.currentUser.id}`;

    return (
      <div>
        <Header />
        <div className="container">
          <aside className="col-md-2">
            <nav className="list-group">
              <Link
                to={`/${userSlug}`}
                className="list-group-item"
                id="user_menu_profile_link">

                My profile
              </Link>

              <Link
                to={`/${userSlug}/friends`}
                className="list-group-item"
                id="user_menu_friends_link">

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
  currentUser: state.users.getCurrentUser()
});

export default connect(mapStateToProps)(Authenticated);
