import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import {setDocumentTitle} from '../../utils';
import Actions from '../../actions/feed';
import Post from '../shared/post';

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

  _loadPosts() {
    const {dispatch, posts} = this.props;
    dispatch(Actions.fetchFeed(posts.length));
  }

  _renderPosts() {
    if (!this.props.posts) return [];

    return this.props.posts.map(post =>
      <Post key={`feed_post_${post.id}`} post={post}/>
    );
  }

  render() {
    return (
      <div id="feed">
        <InfiniteScroll
          items={this._renderPosts()}
          loadMore={::this._loadPosts}
          elementIsScrollable={false}
          holderType="ul"
          className="list-unstyled list-group"/>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  socket: state.socket,
  channel: state.feed.channel,
  posts: state.feed.posts.toArray()
});

export default connect(mapStateToProps)(Feed);
