import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/user';
import Loader from '../components/shared/loader';
import AvatarUploader from './profile/avatar_uploader';
import FriendshipToggler from './shared/friendship_toggler';

class Profile extends React.Component {
  _renderOwnerLinks() {
    const {currentUser, user} = this.props;
    if (currentUser.id !== user.id) return false;

    return (
      <ul className="list-unstyled">
        <li>
          <AvatarUploader user={user} />
        </li>
      </ul>
    )
  }

  _renderVisitorLinks() {
    const {currentUser, user} = this.props;
    if (currentUser.id === user.id) return false;

    return (
      <ul className="list-unstyled">
        <li>
          <FriendshipToggler user={user}/>
        </li>
        <li>
          <Link to={`/user${user.id}/friends`}>
            Friends of {user.first_name}
          </Link>
        </li>
      </ul>
    );
  }

  _renderProfile() {
    const {user} = this.props;
    const fullName = [user.first_name, user.last_name].join(' ');
    const avatarSrc = user.avatar && user.avatar.big || '/images/default_avatar.png';

    setDocumentTitle(fullName);

    return (
      <div>
        <div className="col-sm-3">
          <div>
            <img className="img-responsive" src={avatarSrc} alt={fullName} />
          </div>
          <br />
          {this._renderOwnerLinks()}
          {this._renderVisitorLinks()}
        </div>
        <div className="col-sm-7">
          <h1>{fullName}</h1>
        </div>
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
