import React from 'react';
import {connect} from 'react-redux';
import PostForm from './wall/post_form';
import PostsList from './wall/post_list';

class Wall extends React.Component {
  render() {
    const {user, editable} = this.props;
    const postForm = editable ? <PostForm /> : false;

    return (
      <div id="wall">
        {postForm}
        <PostsList user={user} />
      </div>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  editable: state.users.find(user => user.current).id == ownProps.user.id
});

export default connect(mapStateToProps)(Wall);
