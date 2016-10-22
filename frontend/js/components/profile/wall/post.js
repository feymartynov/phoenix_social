import React from 'react';
import {connect} from 'react-redux';
import {nl2br} from '../../../utils';
import Actions from '../../../actions/posts';
import Avatar from '../../shared/avatar';
import PostEditForm from './post_edit_form';

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

  _renderControls() {
    return (
      <span className="small">
        <button onClick={::this._handleEdit} className="btn-link btn-edit-post">edit</button>
        <button onClick={::this._handleDelete} className="btn-link btn-delete-post">delete</button>
      </span>
    );
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
    const {post, editable} = this.props;
    const date = new Date(post.inserted_at).toLocaleString();
    const controls = editable ? this._renderControls() : false;

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
          {controls}
        </div>
        <div className="clearfix" style={{marginBottom: '0.5em'}}/>
        {this._renderContent()}
      </li>
    );
  }
}

const mapStateToProps = (state, ownProps) => ({
  post: ownProps.post,
  editable: state.users.getCurrentUser().id === ownProps.post.author.id
});

export default connect(mapStateToProps)(Post);
