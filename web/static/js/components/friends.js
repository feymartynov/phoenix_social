import React from 'react';
import {connect} from 'react-redux';
import {Tabs, Tab} from 'react-bootstrap';
import FriendsList from './friends/friends_list';

class Friends extends React.Component {
  static get tabs() {
    return [
      { state: "confirmed", title: "Friends" },
      { state: "pending", title: "Pending" }];
  }

  constructor(props) {
    super(props);
    this.state = {currentTab: 0};
  }

  handleTabToggle(key) {
    this.setState({currentTab: key});
  }

  renderTabTitle(title, badgeValue) {
    if (badgeValue === 0) return title;
    return <span>{title}&nbsp;<span className='badge'>{badgeValue}</span></span>;
  }

  renderTab(index, title, friends) {
    return (
      <Tab
        eventKey={index}
        key={index}
        title={this.renderTabTitle(title, friends.length)}
        disabled={friends.length === 0}>

        <br />
        <FriendsList friends={friends} />
      </Tab>
    );
  }

  render() {
    const tabs = Friends.tabs.map(({state, title}, idx) => {
      const friends = this.props.friends.filter(f => f.friendship_state === state);
      return this.renderTab(idx, title, friends);
    });

    return (
      <div>
        <h1>My friends</h1>

        <Tabs
          activeKey={this.state.currentTab}
          onSelect={::this.handleTabToggle}
          id="friends_lists_tabs">

          {tabs}
        </Tabs>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  friends: state.session.currentUser.friends
});

export default connect(mapStateToProps)(Friends);

