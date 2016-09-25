import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/user';
import Loader from '../components/shared/loader';
import FriendshipToggler from './shared/friendship_toggler';

class Profile extends React.Component {
  _renderVisitorLinks() {
    const {currentUser, user} = this.props;
    if (currentUser.id === user.id) return false;

    return (
      <ul>
        <li className="nav nav-pills">
          <Link to={`/user${user.id}/friends`}>
            Friends of {user.first_name}
          </Link>
        </li>
      </ul>
    );
  }

  _renderProfile() {
    const {first_name, last_name} = this.props.user;
    const fullName = [first_name, last_name].join(' ');

    setDocumentTitle(fullName);

    return (
      <div>
        <h1>{fullName}</h1>
        {this._renderVisitorLinks()}
        <br />
        <FriendshipToggler user={this.props.user}/>
      </div>
    );
  }

  render() {
    const {userId, user, error} = this.props;

    return (
      <Loader
        action={Actions.fetchUser(userId)}
        onLoaded={::this._renderProfile}
        loaded={user && user.id === userId}
        error={error}/>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  userId: parseInt(ownProps.params.userId),
  user: state.users.find(user => user.id === parseInt(ownProps.params.userId)),
  error: state.error,
  currentUser: state.users.find(user => user.current)
});

export default connect(mapStateToProps)(Profile);
