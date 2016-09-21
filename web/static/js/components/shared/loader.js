import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../../utils';

class Loader extends React.Component {
  _renderLoading() {
    return (<div>Loading&hellip;</div>);
  }

  render() {
    if (this.props.loaded) {
      return this.props.onLoaded();
    } else if (this.props.error) {
      setDocumentTitle("Error");
      return false;
    } else {
      this.props.dispatch(this.props.action);
      setDocumentTitle("Loading");
      return this._renderLoading();
    }
  }
}

export default connect(() => ({}))(Loader);
