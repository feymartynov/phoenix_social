import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../../utils';
import Loader from '../shared/loader';
import Actions from '../../actions/profile';
import Tabs from './friends/tabs';

class Friends extends React.Component {
  _renderTitle() {
    const {currentUser, user} = this.props;

    if (currentUser.id === user.id) {
      return "My friends";
    } else {
      return `Friends of ${user.first_name} ${user.last_name}`;
    }
  }

  _renderFriends() {
    const title = this._renderTitle();
    setDocumentTitle(title);

    return (
      <div>
        <h1>{title}</h1>
        <Tabs friends={this.props.user.friends} />
      </div>
    );
  }

  render() {
    const {userId, user, error} = this.props;

    return (
      <Loader
        action={Actions.fetch(userId)}
        onLoaded={::this._renderFriends}
        loaded={user && user.id === userId}
        error={error}/>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  userId: parseInt(ownProps.params.userId),
  user: state.profile,
  currentUser: state.currentUser,
  error: state.error
});

export default connect(mapStateToProps)(Friends);

