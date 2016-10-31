import React from 'react';
import {connect} from 'react-redux';
import Actions from '../../../../actions/wall';

class LiveUpdate extends React.Component {
  componentDidMount() {
    const {dispatch, socket, profile} = this.props;
    dispatch(Actions.connectToChannel(socket, profile.user_id));
  }

  componentWillUnmount() {
    const {dispatch, channel} = this.props;
    dispatch(Actions.reset(channel));
  }

  render() {
    return false;
  }
}

const mapStateToProps = state => ({
  profile: state.profile,
  socket: state.socket,
  channel: state.wall.channel
});

export default connect(mapStateToProps)(LiveUpdate);
