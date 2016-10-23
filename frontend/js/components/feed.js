import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/feed';
import Post from './shared/post';

class Feed extends React.Component {
  componentDidMount() {
    setDocumentTitle('My newsfeed');
  }

  _loadPosts() {
    const {dispatch, feed} = this.props;
    dispatch(Actions.fetchFeed(feed.posts.length));
  }

  _renderPosts() {
    if (!this.props.feed) return [];

    return this.props.feed.posts.map(post =>
      <Post key={post.id} post={post} editable={false} deletable={false}/>
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
  feed: state.feed
});

export default connect(mapStateToProps)(Feed);
