import React from 'react';
import {connect} from 'react-redux';
import InfiniteScroll from 'redux-infinite-scroll';
import Actions from '../../../actions/posts';
import Post from './post';

class PostsList extends React.Component {
  _loadPosts() {
    const {dispatch, user, posts} = this.props;
    dispatch(Actions.fetchWall(user, posts.length));
  }

  render() {
    const posts =
      this.props.posts.map(post =>
        <Post key={`post_${post.id}`} post={post} user={this.props.user} />
      );

    return (
      <InfiniteScroll
        items={posts}
        loadMore={::this._loadPosts}
        elementIsScrollable={false}
        holderType="ul"
        className="list-unstyled list-group"/>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  posts: state.walls.get(ownProps.user.id).toArray(),
});

export default connect(mapStateToProps)(PostsList);

