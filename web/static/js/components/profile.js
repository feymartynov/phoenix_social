import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/profile';
import Loader from '../components/shared/loader';
import FriendshipToggler from './shared/friendship_toggler';

class Profile extends React.Component {
  _renderProfile() {
    const {first_name, last_name} = this.props.user;
    const fullName = [first_name, last_name].join(' ');

    setDocumentTitle(fullName);

    return (
      <div>
        <h1>{fullName}</h1>
        <FriendshipToggler user={this.props.user} />
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
        error={error} />
    );
  }
}

const mapStateToProps = (store, ownProps) => ({
  userId: parseInt(ownProps.params.id),
  user: store.profile.user,
  error: store.error,
  currentUser: store.session.currentUser
});

export default connect(mapStateToProps)(Profile);
