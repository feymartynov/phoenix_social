import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import Actions from '../../../../actions/posts';
import Post from '../../../shared/post';

class PostsList extends React.Component {
  componentWillUnmount() {
    this.props.dispatch(Actions.resetWall());
  }

  _loadPosts() {
    const {dispatch, user, posts} = this.props;
    dispatch(Actions.fetchWall(user, posts.size));
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

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  currentUser: state.currentUser,
  posts: state.wall
});

export default connect(mapStateToProps)(PostsList);
