import React from 'react';
import {connect} from 'react-redux';
import {Link} from 'react-router';

class NotFound extends React.Component {
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
