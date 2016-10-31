import React from 'react';
import {connect} from 'react-redux';
import CreateForm from '../../shared/post/create_form';
import PostsList from './wall/posts_list';
import LiveUpdate from './wall/live_update';
import Actions from '../../../actions/posts';

class Wall extends React.Component {
  _allowPostForm() {
    const {profile, currentUser} = this.props;
    if (profile.user_id === currentUser.id) return true;

    const friendship = profile.friends.get(currentUser.id);
    return friendship && friendship.state === 'confirmed';
  }

  _handlePostSubmit(text) {
    const {dispatch, profile} = this.props;
    dispatch(Actions.create({id: profile.user_id}, text));
  }

  _renderPostForm() {
    const {profile, currentUser} = this.props;

    const placeholder =
      profile.user_id === currentUser.id ? "What's up?" : "Make a post";

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
  profile: state.profile,
  currentUser: state.currentUser
});

export default connect(mapStateToProps)(Wall);
