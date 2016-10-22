import React from 'react';
import {Link} from 'react-router';

const CLASS_NAMES = {
  'big': 'img-responsive',
  'medium': 'img-responsive img-circle',
  'thumb': 'img-responsive img-circle'
};

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
    const {user, version} = this.props;
    const src = this._getImageUrl();
    const fullName = `${user.first_name} ${user.last_name}`.trim();
    const cssClass = CLASS_NAMES[version];

    return (
      <Link to={`/user${user.id}`}>
        <img src={src} alt={fullName} className={cssClass}/>
      </Link>
    );
  }
}
