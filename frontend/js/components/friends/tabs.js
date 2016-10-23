import React from 'react';
import {Tabs as BootstrapTabs, Tab} from 'react-bootstrap';
import List from './list';

const TABS = [
  {state: "confirmed", name: "Friends"},
  {state: "pending", name: "Pending"}
];

export default class Tabs extends React.Component {
  constructor(props) {
    super(props);
    this.state = {currentTabKey: null};
  }

  _getActiveTabKey(tabs) {
    if (this.state.currentTabKey) return this.state.currentTabKey;

    const firstEnabledTab = tabs.find(tab => !tab.props.disabled);
    if (firstEnabledTab) return firstEnabledTab.props.eventKey;
  }

  _handleTabToggle(key) {
    this.setState({currentTabKey: key});
  }

  _renderTitle(state, name, friends) {
    return (
      <span id={`friends_tab_${state}`}>
        {name}&nbsp;
        <span className='badge'>{friends.length}</span>
      </span>
    );
  }

  _renderTabs() {
    return TABS.map(({state, name}, index) => {
      const friends =
        this.props.friends.filter(f => f.state === state).toArray();

      const disabled = friends.length === 0;
      const title = disabled ? name : this._renderTitle(state, name, friends);
      const key = `friends_tab_${index}`;

      return (
        <Tab key={key} eventKey={index} title={title} disabled={disabled}>
          <br />
          <List friends={friends}/>
        </Tab>
      );
    });
  }

  render() {
    const tabs = this._renderTabs();

    if (tabs.find(tab => !tab.props.disabled)) {
      return (
        <BootstrapTabs
          activeKey={this._getActiveTabKey(tabs)}
          onSelect={::this._handleTabToggle}
          id="friends_lists_tabs">

          {tabs}
        </BootstrapTabs>
      );
    } else {
      return <p className="lead">No friends :(</p>;
    }
  }
}