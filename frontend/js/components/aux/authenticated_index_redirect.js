import React from 'react';
import {connect} from 'react-redux';
import {push} from 'react-router-redux';

class AuthenticatedIndexRedirect extends React.Component {
  componentDidMount() {
    const {dispatch, profile} = this.props;
    dispatch(push(`/${profile.slug}`));
  }

  render() {
    return (<div />);
  }
}

const mapStateToProps = state => ({
  profile: state.currentProfile
});

export default connect(mapStateToProps)(AuthenticatedIndexRedirect);
