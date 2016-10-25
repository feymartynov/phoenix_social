import React from 'react';
import {connect} from 'react-redux';
import PostForm from './wall/post_form';
import PostsList from './wall/posts_list';

class Wall extends React.Component {
  _allowPostForm() {
    const {user, currentUser} = this.props;
    if (user.id === currentUser.id) return true;

    const friendship = currentUser.friends.get(user.id);
    return friendship && friendship.state === 'confirmed';
  }

  render() {
    const {user} = this.props;
    const postForm = this._allowPostForm() ? <PostForm user={user}/> : false;

    return (
      <div id="wall">
        {postForm}
        <PostsList user={user}/>
      </div>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  currentUser: state.users.getCurrentUser()
});

export default connect(mapStateToProps)(Wall);
