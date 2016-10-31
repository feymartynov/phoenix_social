import React from 'react';
import {connect} from 'react-redux';
import Constants from '../../../constants';
import Actions from '../../../actions/profile';

class ProfileFields extends React.Component {
  _handleContentEdit(e) {
    const {dispatch, profile} = this.props;

    const changeset = {
      [e.target.getAttribute('data-field')]: e.target.innerText
    };

    dispatch(Actions.update(profile, changeset));
  }

  _renderField(field, label) {
    const value = this.props.profile[field];
    if (!value && !this.props.editable) return false;

    return [
      <dt>{label}</dt>,
      <dd
        data-field={field}
        contentEditable={this.props.editable}
        suppressContentEditableWarning={true}
        onBlur={::this._handleContentEdit}>

        {this.props.profile[field]}
      </dd>];
  }

  render() {
    const fields = Object.keys(Constants.PROFILE_FIELDS).map(field =>
      this._renderField(field, Constants.PROFILE_FIELDS[field])
    );

    return <dl className="dl-horizontal">{fields}</dl>;
  }
}

const mapStateToProps = state => ({
  profile: state.profile
});

export default connect(mapStateToProps)(ProfileFields);
