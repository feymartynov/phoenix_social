import React from 'react';
import ReactDOM from 'react-dom';
import {connect} from 'react-redux';
import {Button, FormGroup, FormControl} from 'react-bootstrap';
import Actions from '../../../actions/posts';

class PostForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {formOpen: false};
  }

  _getText() {
    return ReactDOM.findDOMNode(this.refs.text).value;
  }

  _handleOpen(e) {
    e.preventDefault();
    this.setState({formOpen: true});
  }

  _handleBlur() {
    if (this._getText().length === 0) this.setState({formOpen: false});
  }

  _handleSubmit(e) {
    e.preventDefault();
    const text = this._getText();
    this.props.dispatch(Actions.createPost(text));
  }

  _renderClosed() {
    return (
      <form onFocus={::this._handleOpen}>
        <FormGroup>
          <FormControl type="text" placeholder="How is it going?"/>
        </FormGroup>
      </form>
    );
  }

  _renderOpen() {
    return (
      <form onSubmit={::this._handleSubmit} onBlur={::this._handleBlur}>
        <FormGroup>
          <FormControl
            componentClass="textarea"
            ref="text"
            name="text"
            rows="3"
            autoFocus={true}/>
        </FormGroup>
        <FormGroup className="pull-right">
          <Button type="submit" className="btn-primary btn-send-post">
            Send
          </Button>
        </FormGroup>
        <div className="clearfix"/>
      </form>
    );
  }

  render() {
    return this.state.formOpen ? this._renderOpen() : this._renderClosed();
  }
}

export default connect(() => ({}))(PostForm);