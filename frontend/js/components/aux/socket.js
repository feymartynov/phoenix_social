import React from 'react';
import {connect} from 'react-redux';
import Actions from '../../actions/socket';

class Socket extends React.Component {
  componentDidMount() {
    const {dispatch, socket} = this.props;

    if (!socket) {
      dispatch(Actions.connect());
    }
  }

  render() {
    const {socket, children} = this.props;
    return socket ? <div>{children}</div> : false;
  }
}

const mapStateToProps = (state) => ({
  socket: state.socket
});

export default connect(mapStateToProps)(Socket);
