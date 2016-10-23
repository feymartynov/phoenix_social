import React from 'react';
import {Link} from 'react-router';
import Avatar from '../shared/avatar';
import FriendshipToggler from '../shared/friendship_toggler';

class Friend extends React.Component {
  render() {
    const {friend} = this.props;
    const fullName = `${friend.first_name} ${friend.last_name}`.trim();

    return (
      <li className="list-group-item">
        <div className="pull-left" style={{marginRight: '1em'}}>
          <Avatar
            user={friend}
            version="medium"
            className="img-responsive img-circle"/>
        </div>

        <h4>
          <Link to={`/user${friend.id}`}>{fullName}</Link>
        </h4>

        <FriendshipToggler user={friend} />
        <div className="clearfix" />
      </li>
    );
  }
}

export default class List extends React.Component {
  _renderFriends() {
    return this.props.friends.map((friend, idx) =>
      <Friend key={`friend_${idx}`} friend={friend} />
    );
  }

  render () {
    const {friends} = this.props;
    if (friends.length === 0) return false;
    return <ul className="list-group">{this._renderFriends()}</ul>;
  }
}
