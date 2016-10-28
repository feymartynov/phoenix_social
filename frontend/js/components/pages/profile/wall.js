import React from 'react';
import {connect} from 'react-redux';
import CreateForm from '../../shared/post/create_form';
import PostsList from './wall/posts_list';
import LiveUpdate from './wall/live_update';
import Actions from '../../../actions/posts';

class Wall extends React.Component {
  _allowPostForm() {
    const {user, currentUser} = this.props;
    if (user.id === currentUser.id) return true;

    const friendship = user.friends.get(currentUser.id);
    return friendship && friendship.state === 'confirmed';
  }

  _handlePostSubmit(text) {
    const {dispatch, user} = this.props;
    dispatch(Actions.create(user, text));
  }

  _renderPostForm() {
    const {user, currentUser} = this.props;

    const placeholder =
      user.id === currentUser.id ? "What's up?" : "Make a post";

    return (
      <div id="create_post_form" style={{marginBottom: '1em'}}>
        <CreateForm
          onSubmit={::this._handlePostSubmit}
          placeholder={placeholder}/>
      </div>
    );
  }

  render() {
    const postForm = this._allowPostForm() ? this._renderPostForm() : false;

    return (
      <div id="wall">
        {postForm}
        <PostsList />
        <LiveUpdate />
      </div>
    );
  }
}

const mapStateToProps = state => ({
  user: state.profile,
  currentUser: state.currentUser
});

export default connect(mapStateToProps)(Wall);
