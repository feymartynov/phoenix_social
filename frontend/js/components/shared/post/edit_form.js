import React from 'react';
import ReactDOM from 'react-dom';
import {Button, FormGroup, FormControl} from 'react-bootstrap';

export default class EditForm extends React.Component {
  _handleSubmit(e) {
    e.preventDefault();
    const text = ReactDOM.findDOMNode(this.refs.text).value;
    this.props.onSubmit(text);
    this.props.onDone();
  }

  _handleCancel(e) {
    e.preventDefault();
    this.props.onDone();
  }

  render() {
    return (
      <form onSubmit={::this._handleSubmit} className={this.props.className}>
        <FormGroup>
          <FormControl
            componentClass="textarea"
            ref="text"
            name="text"
            rows="3"
            autoFocus={true}
            defaultValue={this.props.text}/>
        </FormGroup>
        <FormGroup className="pull-right">
          <Button
            className="btn-default btn-cancel-edit"
            onClick={::this._handleCancel}>

            Cancel
          </Button>
          &nbsp;
          <Button type="submit" className="btn-primary btn-submit">
            Send
          </Button>
        </FormGroup>
        <div className="clearfix" />
      </form>
    );
  }
}

