import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import Actions from '../../../../actions/wall';
import Post from '../../../shared/post';

class PostsList extends React.Component {
  _loadPosts() {
    const {dispatch, profile, posts} = this.props;
    dispatch(Actions.fetch(profile, posts.size));
  }

  _renderPosts() {
    const {currentProfile} = this.props;

    return this.props.posts.toArray().map(post => {
      const isAuthor = currentProfile.id === post.author.id;
      const isWallOwner = currentProfile.id === post.profile_id;

      return (
        <Post
          key={`post_${post.id}`}
          post={post}
          editable={isAuthor}
          deletable={isAuthor || isWallOwner}/>
      );
    });
  }

  render() {
    return (
      <InfiniteScroll
        items={this._renderPosts()}
        loadMore={::this._loadPosts}
        elementIsScrollable={false}
        holderType="ul"
        className="list-unstyled"/>
    );
  }
}

const mapStateToProps = state => ({
  profile: state.profile,
  currentProfile: state.currentProfile,
  posts: state.wall.posts,
});

export default connect(mapStateToProps)(PostsList);

