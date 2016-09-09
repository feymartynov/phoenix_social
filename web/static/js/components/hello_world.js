import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../utils';
import SessionActions from '../actions/session';

class HelloWorld extends React.Component {
  componentDidMount() {
    setDocumentTitle('Hello, World!');
  }

  _handleSignOut(e) {
    e.preventDefault();
    this.props.dispatch(SessionActions.signOut());
  }

  render() {
    const {currentUser} = this.props;
    const username = [currentUser.first_name, currentUser.last_name].join(' ');

    return (
      <div>
        <h1>Hello, {username}</h1>
        <a id="sign_out_link" href="#" onClick={::this._handleSignOut}>Sign out</a>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.session.currentUser
});

export default connect(mapStateToProps)(HelloWorld);
