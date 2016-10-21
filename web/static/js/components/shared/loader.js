import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../../utils';

class Loader extends React.Component {
  componentDidMount() {
    const {loaded, action, dispatch} = this.props;
    if (!loaded) dispatch(action);
  }

  render() {
    if (this.props.loaded) {
      return this.props.onLoaded();
    } else if (this.props.error) {
      setDocumentTitle("Error");
      return false;
    } else {
      setDocumentTitle("Loading");
      return <div>Loading&hellip;</div>;
    }
  }
}

export default connect(() => ({}))(Loader);
