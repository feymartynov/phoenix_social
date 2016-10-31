import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../../utils';
import Actions from '../../actions/feed';
import PostsList from './feed/posts_list';

class Feed extends React.Component {
  componentDidMount() {
    const {dispatch, socket} = this.props;
    dispatch(Actions.connectToChannel(socket));
    setDocumentTitle('My newsfeed');
  }

  componentWillUnmount() {
    const {dispatch, channel} = this.props;
    dispatch(Actions.reset(channel));
  }

  render() {
    return (
      <div id="feed">
        <PostsList />
      </div>
    );
  }
}

const mapStateToProps = state => ({
  socket: state.socket,
  channel: state.feed.channel
});

export default connect(mapStateToProps)(Feed);
