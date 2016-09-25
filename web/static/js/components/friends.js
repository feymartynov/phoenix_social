import React from 'react';
import {connect} from 'react-redux';
import {Tabs, Tab} from 'react-bootstrap';
import {setDocumentTitle} from '../utils';
import Loader from './shared/loader';
import FriendsList from './friends/friends_list';
import Actions from '../actions/user';

class Friends extends React.Component {
  static get tabs() {
    return [
      {state: "confirmed", title: "Friends"},
      {state: "pending", title: "Pending"}];
  }

  constructor(props) {
    super(props);
    this.state = {currentTabKey: null};
  }

  _currentTabKey(tabs) {
    if (this.state.currentTabKey) return this.state.currentTabKey;

    const firstEnabledTab = tabs.find(tab => !tab.props.disabled);
    if (firstEnabledTab) return firstEnabledTab.props.eventKey;
  }

  _handleTabToggle(key) {
    this.setState({currentTabKey: key});
  }

  _renderTabTitle(state, title, badgeValue) {
    if (badgeValue === 0) return title;

    return (
      <span id={`friends_tab_${state}`}>
        {title}&nbsp;<span className='badge'>{badgeValue}</span>
      </span>
    );
  }

  _renderTab(index, state, title, friends) {
    return (
      <Tab
        eventKey={index}
        key={index}
        title={this._renderTabTitle(state, title, friends.length)}
        disabled={friends.length === 0}>

        <br />
        <FriendsList friends={friends}/>
      </Tab>
    );
  }

  _renderFriends() {
    setDocumentTitle(this._renderTitle());

    const {friendships, users} = this.props;

    const tabs = Friends.tabs.map(({state, title}, index) => {
      const friends =
        friendships
          .filter(friendshipState => friendshipState === state)
          .map((_, key) => users.find(user => user.id === key.friendId))
          .toArray();

      return this._renderTab(index, state, title, friends);
    });

    let content;

    if (tabs.find(tab => !tab.props.disabled)) {
      content = (
        <Tabs
          activeKey={this._currentTabKey(tabs)}
          onSelect={::this._handleTabToggle}
          id="friends_lists_tabs">

          {tabs}
        </Tabs>
      );
    } else {
      content = <p className="lead">No friends :(</p>
    }

    return (
      <div>
        <h1>{this._renderTitle()}</h1>
        {content}
      </div>
    );
  }

  _renderTitle() {
    const {currentUser, user} = this.props;

    if (currentUser.id === user.id) {
      return "My friends";
    } else {
      return `Friends of ${user.first_name} ${user.last_name}`;
    }
  }

  render() {
    const {userId, user, error} = this.props;

    return (
      <Loader
        action={Actions.fetchUser(userId)}
        onLoaded={::this._renderFriends}
        loaded={user && user.id === userId}
        error={error}/>
    );
  }
}

function userFriendships(state, userId, currentUser) {
  return (
    state.friendships.map
      .filter((friendshipState, key) =>
        key.userId === userId &&
          (friendshipState === "confirmed" || currentUser.id === userId))
  );
}

function mapStateToProps(state, ownProps) {
  const userId = parseInt(ownProps.params.userId);
  const currentUser = state.users.find(user => user.current);

  return {
    userId: userId,
    user: state.users.find(user => user.id === userId),
    users: state.users,
    friendships: userFriendships(state, userId, currentUser),
    error: state.error,
    currentUser: currentUser
  };
}

export default connect(mapStateToProps)(Friends);

