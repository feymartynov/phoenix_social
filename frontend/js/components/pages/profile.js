import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import {setDocumentTitle} from '../../utils';
import Actions from '../../actions/profile';
import Loader from '../shared/loader';
import Avatar from '../shared/avatar';
import AvatarUploader from './profile/avatar_uploader';
import FriendshipToggler from '../shared/friendship_toggler';
import Friends from './profile/friends';
import OnlineFriends from './profile/online_friends';
import ProfileFields from './profile/profile_fields';
import Wall from './profile/wall';

class Profile extends React.Component {
  _renderOwnerLinks() {
    const {profile, editable} = this.props;
    if (!editable) return false;

    return (
      <ul className="list-unstyled">
        <li>
          <AvatarUploader profile={profile}/>
        </li>
      </ul>
    )
  }

  _renderVisitorLinks() {
    const {profile, editable} = this.props;
    if (editable) return false;

    return (
      <ul className="list-unstyled">
        <li>
          <FriendshipToggler profile={profile}/>
        </li>
      </ul>
    );
  }

  _renderFriends() {
    const {profile} = this.props;
    const friends = profile.friends.filter(f => f.state === "confirmed");
    const title = <Link to={`/${profile.slug}/friends`}>Friends</Link>;
    return <Friends friends={friends.toArray()} title={title} id="sample_friends"/>;
  }

  _renderProfile() {
    const {profile, editable} = this.props;
    setDocumentTitle(profile.full_name);

    return (
      <div className="row">
        <div className="col-sm-3">
          <div>
            <Avatar profile={profile} version="big" className="img-responsive"/>
          </div>
          <br />
          {this._renderOwnerLinks()}
          {this._renderVisitorLinks()}
          {this._renderFriends()}
          <OnlineFriends profile={profile}/>
        </div>
        <div className="col-sm-7">
          <h1>{profile.full_name}</h1>
          <ProfileFields editable={editable}/>
          <Wall/>
        </div>
      </div>
    );
  }

  render() {
    const {profileId, profile, error} = this.props;

    return (
      <Loader
        action={Actions.fetch(profileId)}
        onLoaded={::this._renderProfile}
        loaded={profile && profile.id == profileId}
        error={error}/>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  profileId: parseInt(ownProps.params.profileId),
  profile: state.profile,
  editable: state.profile && state.currentUser.id === state.profile.user_id,
  error: state.error
});

export default connect(mapStateToProps)(Profile);
