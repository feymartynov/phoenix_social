import React from 'react';
import {Link} from 'react-router';

export default class Avatar extends React.Component {
  _getImageUrl() {
    const {user, version} = this.props;

    if (user.avatar && user.avatar[version]) {
      return user.avatar[version];
    } else {
      return `/images/default_avatar_${version}.png`;
    }
  }

  render() {
    const {user, className} = this.props;
    const src = this._getImageUrl();
    const fullName = `${user.first_name} ${user.last_name}`.trim();

    return (
      <Link to={`/user${user.id}`}>
        <img src={src} alt={fullName} className={className}/>
      </Link>
    );
  }
}
