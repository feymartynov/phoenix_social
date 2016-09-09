import React from 'react';
import ReactDOM from 'react-dom';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import {FormControl, Button} from 'react-bootstrap';
import FormGroup from '../components/shared/validated_form_group';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/session';

class SignUp extends React.Component {
  componentDidMount() {
    setDocumentTitle('Sign up');
  }

  _handleSubmit(e) {
    e.preventDefault();

    console.log(this.refs);

    const userData = {
      first_name: ReactDOM.findDOMNode(this.refs.firstName).value,
      last_name: ReactDOM.findDOMNode(this.refs.lastName).value,
      email: ReactDOM.findDOMNode(this.refs.email).value,
      password: ReactDOM.findDOMNode(this.refs.password).value,
      password_confirmation: ReactDOM.findDOMNode(this.refs.passwordConfirmation).value
    };

    this.props.dispatch(Actions.signUp(userData));
  }

  render() {
    const errors = this.props.signUpErrors;

    return (
      <div>
        <h1>Sign up</h1>
        <form onSubmit={::this._handleSubmit}>
          <FormGroup errors={errors} field="first_name">
            <FormControl
              ref="firstName"
              type="text"
              placeholder="First name"
              required="true" />
          </FormGroup>

          <FormGroup errors={errors} field="last_name">
            <FormControl
              ref="lastName"
              type="text"
              placeholder="Last name"
              required="true" />
          </FormGroup>

          <FormGroup errors={errors} field="email">
            <FormControl
              ref="email"
              type="email"
              placeholder="Email"
              required="true" />
          </FormGroup>

          <FormGroup errors={errors} field="password">
            <FormControl
              ref="password"
              type="password"
              placeholder="Password"
              required="true" />
          </FormGroup>

          <FormGroup errors={errors} field="password_confirmation">
            <FormControl
              ref="passwordConfirmation"
              type="password"
              placeholder="Password confirmation"
              required="true" />
          </FormGroup>

          <Button type="submit" bsStyle="primary">Sign up</Button>
        </form>

        <hr />

        <div>
          Already have an account? <Link to="/sign_in">Sign in</Link>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => state.session;
export default connect(mapStateToProps)(SignUp);
