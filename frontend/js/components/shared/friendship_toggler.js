import React from 'react';
import {connect} from 'react-redux';
import Actions from '../../actions/friendships';

class FriendshipToggler extends React.Component {
  _handleAddClick(e) {
    e.preventDefault();
    this.props.dispatch(Actions.addToFriends(this.props.user));
  }

  _handleRemoveClick(e) {
    e.preventDefault();
    this.props.dispatch(Actions.removeFromFriends(this.props.user));
  }

  _renderAddButton() {
    return (
      <button
        className="btn btn-primary btn-add-friend"
        onClick={::this._handleAddClick}>
        Add to friends
      </button>
    );
  }

  _renderRemoveButton() {
    return (
      <button
        className="btn btn-danger btn-remove-friend"
        onClick={::this._handleRemoveClick}>
        Remove from friends
      </button>
    );
  }

  render() {
    const {user, currentUser} = this.props;
    const friendship = currentUser.friends.get(user.id);

    if (user.id === currentUser.id) {
      return false;
    } else if (friendship && friendship.state === "confirmed") {
      return this._renderRemoveButton();
    } else {
      return this._renderAddButton();
    }
  }
}

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  currentUser: state.currentUser
});

export default connect(mapStateToProps)(FriendshipToggler);
