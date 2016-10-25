import React from 'react';
import {connect} from 'react-redux';
import {push} from 'react-router-redux';

class AuthenticatedIndexRedirect extends React.Component {
  componentDidMount() {
    this.props.dispatch(push(`/user${this.props.currentUser.id}`));
  }

  render() {
    return (<div />);
  }
}

const mapStateToProps = state => ({
  currentUser: state.users.getCurrentUser()
});

export default connect(mapStateToProps)(AuthenticatedIndexRedirect);
