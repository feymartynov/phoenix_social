import React from 'react';

export default class MainLayout extends React.Component {
  render() {
    return <div>{this.props.children}</div>;
  }
}
