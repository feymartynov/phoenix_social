import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import FriendshipToggler from '../shared/friendship_toggler';

class FriendsListItem extends React.Component {
  render() {
    const {friend} = this.props;

    return (
      <li className="list-group-item">
        <h4>
          <Link to={`/user${friend.id}`}>
            {friend.first_name} {friend.last_name}
          </Link>
        </h4>
        <FriendshipToggler user={friend} />
      </li>
    );
  }
}

export default class FriendsList extends React.Component {
  render () {
    const friends = this.props.friends.filter(friend =>
      !["rejected", "cancelled"].includes(friend.friendship_state));

    if (friends.length === 0) return false;

    return (
      <ul className="list-group">
        {friends.map((friend, i) => <FriendsListItem key={i} friend={friend} />)}
      </ul>
    );
  }
}
