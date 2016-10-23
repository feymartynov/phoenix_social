import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import Actions from '../../../actions/posts';
import Post from '../../shared/post';

class PostsList extends React.Component {
  _loadPosts() {
    const {dispatch, user, posts} = this.props;
    dispatch(Actions.fetchWall(user, posts.length));
  }

  _renderPosts() {
    const {currentUser} = this.props;

    return this.props.posts.map(post => {
      const editable = currentUser.id === post.author.id;
      const authorizedUsersIds = [post.user_id, post.author.id];
      const deletable = authorizedUsersIds.includes(currentUser.id);

      return (
        <Post
          key={post.id}
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
        className="list-unstyled list-group"/>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  currentUser: state.users.getCurrentUser(),
  posts: state.walls.get(ownProps.user.id).toArray()
});

export default connect(mapStateToProps)(PostsList);

