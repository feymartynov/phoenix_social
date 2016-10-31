import React from 'react';
import {connect} from 'react-redux';
import Friends from './friends';

class OnlineFriends extends React.Component {
  render() {
    const friends =
      this.props.profile.friends.filter(friend =>
        friend.state === "confirmed" &&
          !!this.props.presences[friend.user_id]);

    return (
      <Friends
        friends={friends.toArray()}
        title="Friends online"
        id="sample_online_friends"/>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  profile: ownProps.profile,
  presences: state.presence.presences
});

export default connect(mapStateToProps)(OnlineFriends);
