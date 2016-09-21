import React from 'react';
import {connect} from 'react-redux';
import {Tabs, Tab} from 'react-bootstrap';
import Loader from './shared/loader';
import FriendsList from './friends/friends_list';
import Actions from '../actions/profile';

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

  _handleTabToggle(key) {
    this.setState({currentTabKey: key});
  }

  _renderTabTitle(title, badgeValue) {
    if (badgeValue === 0) return title;
    return <span>{title}&nbsp;<span className='badge'>{badgeValue}</span></span>;
  }

  _renderTab(index, title, friends) {
    return (
      <Tab
        eventKey={index}
        key={index}
        title={this._renderTabTitle(title, friends.length)}
        disabled={friends.length === 0}>

        <br />
        <FriendsList friends={friends}/>
      </Tab>
    );
  }

  _renderFriends() {
    const tabs = Friends.tabs.map(({state, title}, idx) => {
      const friends = this.props.user.friends
        .filter(f => f.friendship_state === state);

      return this._renderTab(idx, title, friends);
    });

    const currentTabKey =
      this.state.currentTabKey ||
      tabs.find(tab => !tab.props.disabled).props.eventKey;

    return (
      <div>
        <h1>My friends</h1>

        <Tabs
          activeKey={currentTabKey}
          onSelect={::this._handleTabToggle}
          id="friends_lists_tabs">

          {tabs}
        </Tabs>
      </div>
    );
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

const mapStateToProps = (state, ownProps) => ({
  userId: parseInt(ownProps.params.userId),
  user: state.profile.user,
  error: state.error
});

export default connect(mapStateToProps)(Friends);

