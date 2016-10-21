import React from 'react';
import {connect} from 'react-redux';
import {Alert} from 'react-bootstrap';
import Actions from '../../actions/error';

class Error extends React.Component {
  _handleDismiss() {
    this.props.dispatch(Actions.dismiss());
  }

  _renderErrorText() {
    const {error} = this.props;
    if (typeof(error) !== 'object') return error;

    const errors =
      Array.prototype.concat.apply([],
        Object.keys(error).map(key => {
          const humanizedKey =
            key[0].toUpperCase() + key.slice(1).replace('_', ' ');

          return error[key].map((message, idx) =>
            <li key={`${key}_${idx}`}>{humanizedKey} {message}</li>
          );
        })
      );

    return <ul>{errors}</ul>;
  }

  render() {
    if (!this.props.error) return false;

    return (
      <Alert bsStyle="danger" onDismiss={::this._handleDismiss}>
        {this._renderErrorText()}
      </Alert>
    );
  }
}

const mapStateToProps = state => ({
  error: state.error
});

export default connect(mapStateToProps)(Error);
