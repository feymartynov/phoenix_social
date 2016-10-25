import React from 'react';
import _ from 'lodash';
import {Link} from 'react-router';
import Avatar from '../../shared/avatar';

class Friend extends React.Component {
  render() {
    const {user} = this.props;

    return (
      <li
        className="text-center pull-left"
        style={{width: '33.3%', marginBottom: '0.5em'}}>

        <Avatar user={user} version="thumb" className="img-circle"/>
        <Link to={`/user${user.id}`}>{user.first_name}</Link>
      </li>
    );
  }
}

export default class Friends extends React.Component {
  _renderFriends() {
    return _.sampleSize(this.props.friends, 6).map(user =>
      <Friend key={`friend_${user.id}`} user={user}/>
    );
  }

  render() {
    if (this.props.friends.length == 0) return false;

    return (
      <div className="panel panel-default" id={this.props.id}>
        <div className="panel-body">
          <h5>
            {this.props.title}&nbsp;
            <span className="text-muted">({this.props.friends.length})</span>
          </h5>

          <ul className="list-unstyled">{this._renderFriends()}</ul>
        </div>
      </div>
    );
  }
}
