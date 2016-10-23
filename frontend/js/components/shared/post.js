import React from 'react';
import {connect} from 'react-redux';
import {nl2br} from '../../utils';
import Actions from '../../actions/posts';
import Avatar from './avatar';
import PostEditForm from '../profile/wall/post_edit_form';

class Post extends React.Component {
  constructor(props) {
    super(props);
    this.state = {editing: false};
  }

  _handleEdit(e) {
    e.preventDefault();
    this.setState({editing: true});
  }

  _handleCancelEdit() {
    this.setState({editing: false});
  }

  _handleDelete(e) {
    e.preventDefault();
    this.props.dispatch(Actions.deletePost(this.props.post));
  }

  _renderEditButton() {
    if (!this.props.editable) return false;

    return (
      <button
        className="btn-link btn-edit-post"
        onClick={::this._handleEdit}>

        edit
      </button>
    );
  }

  _renderDeleteButton() {
    if (!this.props.deletable) return false;

    return (
      <button
        className="btn-link btn-delete-post"
        onClick={::this._handleDelete}>

        delete
      </button>
    );
  }

  _renderControls() {
    const editButton = this._renderEditButton();
    const deleteButton = this._renderDeleteButton();

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

  _renderContent() {
    if (this.state.editing) {
      return (
        <PostEditForm
          post={this.props.post}
          onDone={::this._handleCancelEdit} />
      );
    } else {
      return <article>{nl2br(this.props.post.text)}</article>;
    }
  }

  render() {
    const {post} = this.props;
    const date = new Date(post.inserted_at).toLocaleString();

    return (
      <li key={`post_${post.id}`} className="list-group-item" data-post-id={post.id}>
        <div>
          <div className="pull-left" style={{marginRight: '0.5em'}}>
            <Avatar user={post.author} version="thumb"/>
          </div>
          <strong>{post.author.first_name} {post.author.last_name}</strong>
        </div>
        <div>
          <time dateTime={post.inserted_at} className="small text-muted">
            {date}
          </time>
          {this._renderControls()}
        </div>
        <div className="clearfix" style={{marginBottom: '0.5em'}}/>
        {this._renderContent()}
      </li>
    );
  }
}

export default connect(() => ({}))(Post);
