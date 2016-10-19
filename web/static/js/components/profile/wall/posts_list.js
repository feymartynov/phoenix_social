import React from 'react';
import {connect} from 'react-redux';
import Loader from '../../shared/loader';
import Actions from '../../../actions/posts';
import Post from './post';

class PostsList extends React.Component {
  _renderPostsList() {
    const posts =
      this.props.posts.map(post =>
        <Post key={`post_${post.id}`}
              post={post}
              user={this.props.user} />
      );

    return <ul className="list-unstyled list-group">{posts}</ul>;
  }

  render() {
    const {user, posts, error} = this.props;

    return (
      <Loader
        action={Actions.fetchWall(user)}
        onLoaded={::this._renderPostsList}
        loaded={posts}
        error={error}/>
    )
  }
}

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  error: state.error,
  posts: state.walls.get(ownProps.user.id)
});

export default connect(mapStateToProps)(PostsList);

