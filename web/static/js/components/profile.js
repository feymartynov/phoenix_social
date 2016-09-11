import React from 'react';
import {connect} from 'react-redux';
import {setDocumentTitle} from '../utils';
import Actions from '../actions/profile';
import Loader from '../components/shared/loader';

class Profile extends React.Component {
  componentDidMount() {
    this.props.dispatch(Actions.fetchUser(this.props.userId));
  }

  _renderProfile() {
    const {first_name, last_name} = this.props.user;
    const fullName = [first_name, last_name].join(' ');

    setDocumentTitle(fullName);

    return (
      <div>
        <h1>{fullName}</h1>
      </div>
    );
  }

  render() {
    return (
      <Loader
        onLoaded={::this._renderProfile}
        loaded={this.props.user}
        error={this.props.error} />
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  userId: ownProps.params.id,
  user: state.profile.user,
  error: state.profile.error
});

export default connect(mapStateToProps)(Profile);
