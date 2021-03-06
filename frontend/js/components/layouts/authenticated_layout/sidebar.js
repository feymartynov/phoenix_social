import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';

class Sidebar extends React.Component {
  render() {
    const userSlug = `user${this.props.currentUser.id}`;

    return (
      <aside className="col-md-2">
        <nav className="list-group">
          <Link
            to={`/${userSlug}`}
            className="list-group-item"
            id="user_menu_profile_link">

            My profile
          </Link>

          <Link
            to="/feed"
            className="list-group-item"
            id="user_menu_feed_link">

            My newsfeed
          </Link>

          <Link
            to={`/${userSlug}/friends`}
            className="list-group-item"
            id="user_menu_friends_link">

            My friends
          </Link>
        </nav>
      </aside>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.currentUser
});

export default connect(mapStateToProps)(Sidebar);
