import React from 'react';
import {connect} from 'react-redux';
import Constants from '../../../constants';
import Actions from '../../../actions/CURRENT_user';

class ProfileFields extends React.Component {
  _handleContentEdit(e) {
    const changeset = {
      [e.target.getAttribute('data-field')]: e.target.innerText
    };

    this.props.dispatch(Actions.update(changeset));
  }

  _renderField(field, label) {
    const value = this.props.user[field];
    if (!value && !this.props.editable) return false;

    return [
      <dt>{label}</dt>,
      <dd
        data-field={field}
        contentEditable={this.props.editable}
        suppressContentEditableWarning={true}
        onBlur={::this._handleContentEdit}>

        {this.props.user[field]}
      </dd>];
  }

  render() {
    const fields = Object.keys(Constants.PROFILE_FIELDS).map(field =>
      this._renderField(field, Constants.PROFILE_FIELDS[field])
    );

    return <dl className="dl-horizontal">{fields}</dl>;
  }
}

export default connect(() => ({}))(ProfileFields);
