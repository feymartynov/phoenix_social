import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';

class FriendsListItem extends React.Component {
  render() {
    const {friend} = this.props;
    let label;

    if (friend.friendship_state == "pending") {
      label = (<span className="label label-warning">pending</span>);
    }

    return (
      <li>
        <Link to={`/user${friend.id}`}>
          {friend.first_name} {friend.last_name}
        </Link>
        &nbsp;{label}
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
      <div>
        <h2>Friends</h2>
        <ul>
          {friends.map((friend, i) => <FriendsListItem key={i} friend={friend} />)}
        </ul>
      </div>
    );
  }
}
