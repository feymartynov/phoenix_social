import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../../utils';
import Loader from '../shared/loader';
import Actions from '../../actions/profile';
import Tabs from './friends/tabs';

class Friends extends React.Component {
  _renderTitle() {
    const {currentUser, profile} = this.props;

    if (currentUser.id === profile.user_id) {
      return "My friends";
    } else {
      return `Friends of ${profile.full_name}`;
    }
  }

  _renderFriends() {
    const title = this._renderTitle();
    setDocumentTitle(title);

    return (
      <div>
        <h1>{title}</h1>
        <Tabs friends={this.props.profile.friends} />
      </div>
    );
  }

  render() {
    const {profileId, profile, error} = this.props;

    return (
      <Loader
        action={Actions.fetch(profileId)}
        onLoaded={::this._renderFriends}
        loaded={profile && profile.id === profileId}
        error={error}/>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  profileId: parseInt(ownProps.params.profileId),
  profile: state.profile,
  currentUser: state.currentUser,
  error: state.error
});

export default connect(mapStateToProps)(Friends);

