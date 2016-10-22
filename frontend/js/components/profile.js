import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/user';
import Loader from './shared/loader';
import Avatar from './shared/avatar';
import AvatarUploader from './profile/avatar_uploader';
import FriendshipToggler from './shared/friendship_toggler';
import ProfileFields from './profile/profile_fields';
import Wall from './profile/wall';

class Profile extends React.Component {
  _renderOwnerLinks() {
    const {user, editable} = this.props;
    if (!editable) return false;

    return (
      <ul className="list-unstyled">
        <li>
          <AvatarUploader user={user}/>
        </li>
      </ul>
    )
  }

  _renderVisitorLinks() {
    const {user, editable} = this.props;
    if (editable) return false;

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
    const {user, editable} = this.props;
    const fullName = `${user.first_name} ${user.last_name}`.trim();
    setDocumentTitle(fullName);

    return (
      <div className="row">
        <div className="col-sm-3">
          <div>
            <Avatar user={user} version="big"/>
          </div>
          <br />
          {this._renderOwnerLinks()}
          {this._renderVisitorLinks()}
        </div>
        <div className="col-sm-7">
          <h1>{fullName}</h1>
          <ProfileFields user={user} editable={editable}/>
          <Wall user={user}/>
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
        loaded={user}
        error={error}/>
    );
  }
}

function mapStateToProps(state, ownProps) {
  const userId = parseInt(ownProps.params.userId);
  const currentUser = state.users.getCurrentUser()
  const user = state.users.get(userId);

  return {
    userId: userId,
    user: user,
    error: state.error,
    editable: currentUser.id === userId,
  };
}

export default connect(mapStateToProps)(Profile);
