import React from 'react';
import {connect} from 'react-redux';
import {push} from 'react-router-redux';

class AuthenticatedIndex extends React.Component {
  componentDidMount() {
    this.props.dispatch(push(`/user${this.props.currentUser.id}`));
  }

  render() {
    return (<div />);
  }
}

const mapStateToProps = state => ({
  currentUser: state.users.find(user => user.current)
});

export default connect(mapStateToProps)(AuthenticatedIndex);
