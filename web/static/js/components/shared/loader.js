import React from 'react';
import {setDocumentTitle} from '../../utils';

export default class Loader extends React.Component {
  _renderLoading() {
    return (<div>Loading&hellip;</div>);
  }

  _renderError() {
    return (
      <div>
        <h1>Error</h1>
        <p className="lead">{this.props.error}</p>
      </div>
    );
  }

  render() {
    if (this.props.loaded) {
      return this.props.onLoaded();
    } else if (this.props.error) {
      setDocumentTitle("Error");
      return this._renderError();
    } else {
      setDocumentTitle("Loading");
      return this._renderLoading();
    }
  }
}
