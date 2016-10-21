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

  _renderTabs(tabs) {
    if (tabs.find(tab => !tab.props.disabled)) {
      return (
        <Tabs
          activeKey={this._currentTabKey(tabs)}
          onSelect={::this._handleTabToggle}
          id="friends_lists_tabs">

          {tabs}
        </Tabs>
      );
    } else {
      return <p className="lead">No friends :(</p>;
    }
  }

  _renderFriends() {
    const {user} = this.props;
    const title = this._renderTitle();
    setDocumentTitle(title);

    const tabs = Friends.tabs.map(({state, title}, index) => {
      const friends = user.friends.filter(f => f.state === state).toArray();
      return this._renderTab(index, state, title, friends);
    });

    return (
      <div>
        <h1>{title}</h1>
        {this._renderTabs(tabs)}
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

function mapStateToProps(state, ownProps) {
  const userId = parseInt(ownProps.params.userId);

  return {
    userId: userId,
    user: state.users.get(userId),
    currentUser: state.users.getCurrentUser(),
    error: state.error
  };
}

export default connect(mapStateToProps)(Friends);

