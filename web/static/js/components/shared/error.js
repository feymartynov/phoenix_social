import React from 'react';
import {connect} from 'react-redux';
import {Alert} from 'react-bootstrap';
import Actions from '../../actions/error';

class Error extends React.Component {
  _handleDismiss() {
    this.props.dispatch(Actions.dismiss());
  }

  render() {
    if (!this.props.error) return false;

    return (
      <Alert bsStyle="danger" onDismiss={::this._handleDismiss}>
        {this.props.error}
      </Alert>
    );
  }
}

const mapStateToProps = state => ({
  error: state.error
});

export default connect(mapStateToProps)(Error);
