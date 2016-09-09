import React from 'react';
import {connect} from 'react-redux';

class Authenticated extends React.Component {
  render() {
    if (!this.props.currentUser) return false;
    return (<div>{this.props.children}</div>);
  }
}

const mapStateToProps = state => ({
  currentUser: state.session.currentUser
});

export default connect(mapStateToProps)(Authenticated);
