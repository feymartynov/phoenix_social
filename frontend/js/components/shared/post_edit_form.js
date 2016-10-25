import React from 'react';
import ReactDOM from 'react-dom';
import {connect} from 'react-redux';
import {Button, FormGroup, FormControl} from 'react-bootstrap';
import Actions from '../../actions/posts';

class PostEditForm extends React.Component {
  _handleSubmit(e) {
    e.preventDefault();
    const {dispatch, post} = this.props;
    const text = ReactDOM.findDOMNode(this.refs.text).value;
    dispatch(Actions.editPost(post, text));
    this.props.onDone();
  }

  _handleCancel(e) {
    e.preventDefault();
    this.props.onDone();
  }

  render() {
    return (
      <form onSubmit={::this._handleSubmit} className="post-edit-form">
        <FormGroup>
          <FormControl
            componentClass="textarea"
            ref="text"
            name="text"
            rows="3"
            autoFocus={true}
            defaultValue={this.props.post.text}/>
        </FormGroup>
        <FormGroup className="pull-right">
          <Button
            className="btn-default btn-cancel-edit-post"
            onClick={::this._handleCancel}>

            Cancel
          </Button>
          &nbsp;
          <Button type="submit" className="btn-primary btn-send-post">
            Send
          </Button>
        </FormGroup>
        <div className="clearfix" />
      </form>
    );
  }
}

export default connect(() => ({}))(PostEditForm);
