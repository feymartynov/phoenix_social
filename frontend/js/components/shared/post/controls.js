import React from 'react';

export default class Controls extends React.Component {
  _renderEditButton() {
    return (
      <button className="btn-link btn-edit" onClick={this.props.onEdit}>
        edit
      </button>
    );
  }

  _renderDeleteButton() {
    return (
      <button className="btn-link btn-delete" onClick={this.props.onDelete}>
        delete
      </button>
    );
  }

  render() {
    const {onEdit, onDelete} = this.props;

    const editButton = onEdit ? this._renderEditButton() : false;
    const deleteButton = onDelete ? this._renderDeleteButton() : false;

    if (editButton || deleteButton) {
      return (
        <span className="small">
          {editButton}
          {deleteButton}
        </span>
      );
    } else {
      return false;
    }
  }
}
