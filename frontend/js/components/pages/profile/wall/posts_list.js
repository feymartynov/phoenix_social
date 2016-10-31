import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import Actions from '../../../../actions/wall';
import Post from '../../../shared/post';

class PostsList extends React.Component {
  _loadPosts() {
    const {dispatch, profile, posts} = this.props;
    dispatch(Actions.fetch(profile.user_id, posts.size));
  }

  _renderPosts() {
    const {currentUser} = this.props;

    return this.props.posts.toArray().map(post => {
      const editable = currentUser.id === post.author.id;
      const authorizedUsersIds = [post.user_id, post.author.id];
      const deletable = authorizedUsersIds.includes(currentUser.id);

      return (
        <Post
          key={`post_${post.id}`}
          post={post}
          editable={editable}
          deletable={deletable}/>
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
  currentUser: state.currentUser,
  posts: state.wall.posts,
});

export default connect(mapStateToProps)(PostsList);

