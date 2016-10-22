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
          <Avatar user={friend} version="medium"/>
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
  render () {
    const {friends} = this.props;
    if (friends.length === 0) return false;

    return (
      <ul className="list-group">
        {friends.map((friend, i) => <Friend key={i} friend={friend} />)}
      </ul>
    );
  }
}
