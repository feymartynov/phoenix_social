import React from 'react';
import {connect} from 'react-redux';
import Actions from '../../actions/presence';

class Presence extends React.Component {
  componentDidMount() {
    const {dispatch, socket, channel} = this.props;

    if (!channel) {
      dispatch(Actions.connectToChannel(socket));
    }
  }

  componentWillUnmount() {
    const {dispatch, channel} = this.props;

    if (channel) {
      dispatch(Actions.disconnectFromChannel(channel));
    }
  }

  render() {
    return false;
  }
}

const mapStateToProps = (state) => ({
  socket: state.socket,
  channel: state.presence.channel
});

export default connect(mapStateToProps)(Presence);
