import React from 'react';
import {connect} from 'react-redux';
import PostForm from './wall/post_form';
import PostsList from './wall/posts_list';

class Wall extends React.Component {
  render() {
    const {user, currentUser} = this.props;
    const allowPostForm = user.id === currentUser.id;
    const postForm = allowPostForm ? <PostForm user={user}/> : false;

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
