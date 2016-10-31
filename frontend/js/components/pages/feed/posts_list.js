import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import Actions from '../../../actions/feed';
import Post from '../../shared/post';

class PostsList extends React.Component {
  _loadPosts() {
    const {dispatch, posts} = this.props;
    dispatch(Actions.fetch(posts.size));
  }

  _renderPosts() {
    if (!this.props.posts) return [];

    return this.props.posts.toArray().map(post =>
      <Post key={`feed_post_${post.id}`} post={post}/>
    );
  }

  render() {
    return (
      <InfiniteScroll
        items={this._renderPosts()}
        loadMore={::this._loadPosts}
        elementIsScrollable={false}
        holderType="ul"
        className="list-unstyled list-group"/>
    );
  }
}

const mapStateToProps = state => ({
  posts: state.feed.posts
});

export default connect(mapStateToProps)(PostsList);
