import React from 'react';
import {connect} from 'react-redux';
import Header from '../components/shared/header';

class Authenticated extends React.Component {
  render() {
    if (!this.props.currentUser) return false;

    return (
      <div>
        <Header />
        <div className="container">{this.props.children}</div>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.session.currentUser
});

export default connect(mapStateToProps)(Authenticated);
