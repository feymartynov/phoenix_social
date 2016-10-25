import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';
import {setDocumentTitle} from '../../utils';

class NotFound extends React.Component {
  componentDidMount() {
    setDocumentTitle("Page not found");
  }

  render() {
    return (
      <div>
        <h1><strong>404</strong> Page not found</h1>
        <Link to="/">Get back to the home page</Link>
      </div>
    );
  }
}

export default connect(() => ({}))(NotFound);
