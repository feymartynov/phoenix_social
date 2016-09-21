import React from 'react';
import {connect} from 'react-redux';
import Actions from '../../actions/profile';

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
        className="btn btn-primary"
        onClick={::this._handleAddClick}>
        Add to friends
      </button>
    );
  }

  _renderRemoveButton() {
    return (
      <button
        className="btn btn-danger"
        onClick={::this._handleRemoveClick}>
        Remove from friends
      </button>
    );
  }

  render() {
    const {user, currentUser} = this.props;
    if (user.id === currentUser.id) return false;

    const friend = currentUser.friends.find(friend => friend.id === user.id);

    if (!friend || friend.friendship_state != "confirmed") {
      return this._renderAddButton();
    } else {
      return this._renderRemoveButton();
    }
  }
}

const mapStateToProps = (state, ownProps) => ({
  user: ownProps.user,
  currentUser: state.session.currentUser
});

export default connect(mapStateToProps)(FriendshipToggler);
