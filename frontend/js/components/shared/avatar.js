import React from 'react';
import {Link} from 'react-router';

export default class Avatar extends React.Component {
  _getImageUrl() {
    const {profile, version} = this.props;

    if (profile.avatar && profile.avatar[version]) {
      return profile.avatar[version];
    } else {
      return `/images/default_avatar_${version}.png`;
    }
  }

  render() {
    const {profile, className} = this.props;
    const src = this._getImageUrl();

    return (
      <Link to={`/${profile.slug}`}>
        <img src={src} alt={profile.full_name} className={className}/>
      </Link>
    );
  }
}
