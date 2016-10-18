import React from 'react';
import {connect} from 'react-redux';
import {nl2br} from '../../../utils';
import Loader from '../../shared/loader';
import Actions from '../../../actions/posts';

class PostsList extends React.Component {
  _renderPost(post) {
    const date = new Date(post.inserted_at).toLocaleString();

    return (
      <li key={`post_${post.id}`} className="list-group-item">
        <time dateTime={post.inserted_at} className="text-muted">{date}</time>
        <article>{nl2br(post.text)}</article>
      </li>
    );
  }

  _renderPostsList() {
    const posts = this.props.posts.map(this._renderPost);
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

