import React from 'react';
import {connect} from 'react-redux';
import {nl2br} from '../../../utils';
import Avatar from '../avatar';
import Controls from './controls';
import EditForm from './edit_form';
import Actions from '../../../actions/comments';

class Comment extends React.Component {
  constructor(props) {
    super(props);
    this.state = {editing: false};
  }

  _handleEdit(e) {
    e.preventDefault();
    this.setState({editing: true});
  }

  _handleEditSubmit(text) {
    const {dispatch, comment} = this.props;
    dispatch(Actions.edit(comment, text));
  }

  _handleEditDone() {
    this.setState({editing: false});
  }

  _handleDelete(e) {
    e.preventDefault();
    this.props.dispatch(Actions.delete(this.props.comment));
  }

  _renderContent() {
    if (this.state.editing) {
      return (
        <EditForm
          className="post-edit-comment"
          text={this.props.comment.text}
          onSubmit={::this._handleEditSubmit}
          onDone={::this._handleEditDone} />
      );
    } else {
      return <p>{nl2br(this.props.comment.text)}</p>;
    }
  }

  render() {
    const {comment, editable, deletable} = this.props;
    const date = new Date(comment.inserted_at).toLocaleString();
    const onEdit = editable ? ::this._handleEdit : false;
    const onDelete = deletable ? ::this._handleDelete : false;

    return (
      <li className="media" data-comment-id={comment.id} style={{borderBottom: '1px solid #ddd'}}>
        <div className="media-left">
          <Avatar
            user={comment.author}
            version="thumb"
            className="img-circle"/>
        </div>
        <div className="media-body">
          <div>
            <strong>{comment.author.first_name} {comment.author.last_name}</strong>
          </div>
          <div>
            <time dateTime={comment.inserted_at} className="small text-muted">
              {date}
            </time>
            <Controls onEdit={onEdit} onDelete={onDelete} />
          </div>
          {this._renderContent()}
        </div>
      </li>
    );
  }
}

export default connect(() => ({}))(Comment);
