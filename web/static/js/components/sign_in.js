import React from 'react';
import ReactDOM from 'react-dom';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import {FormGroup, FormControl, Button, Alert} from 'react-bootstrap';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/session';

class SignIn extends React.Component {
  componentDidMount() {
    setDocumentTitle('Sign in');
  };

  _handleSubmit(e) {
    e.preventDefault();

    const sessionData = {
      email: ReactDOM.findDOMNode(this.refs.email).value,
      password: ReactDOM.findDOMNode(this.refs.password).value
    };

    this.props.dispatch(Actions.signIn(sessionData));
  }

  _renderError() {
    return this.props.signInError && (
      <Alert bsStyle="danger">{this.props.signInError}</Alert>
    );
  }

  render() {
    return (
      <div>
        <h1>Sign in</h1>

        {::this._renderError()}

        <form onSubmit={::this._handleSubmit}>
          <FormGroup>
            <FormControl
              ref="email"
              type="email"
              placeholder="Email"
              required="true"  />
          </FormGroup>

          <FormGroup>
            <FormControl
              ref="password"
              type="password"
              placeholder="Password"
              required="true" />
          </FormGroup>

          <Button type="submit" bsStyle="primary">Sign in</Button>
        </form>

        <hr />

        <div>
          Don't have an account? <Link to="/sign_up">Sign up</Link>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => state.session;
export default connect(mapStateToProps)(SignIn);
