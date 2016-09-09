import React from 'react';
import {FormGroup, HelpBlock} from 'react-bootstrap';

export default class ValidatedFormGroup extends React.Component {
  _getValidationState() {
    const {errors, field} = this.props;
    const hasError = errors && errors[field] && errors[field].length > 0;
    return hasError ? 'error' : null;
  }

  _renderMessage() {
    const {errors, field} = this.props;
    if (!errors || !errors[field]) return false;
    return errors[field].map(error => <HelpBlock>{error}</HelpBlock>);
  }

  render() {
    return (
      <FormGroup validationState={this._getValidationState()}>
        {this.props.children}
        {this._renderMessage()}
      </FormGroup>
    );
  }
}
