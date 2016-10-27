import React from 'react';
import {connect} from 'react-redux';
import {nl2br} from '../../utils';
import PostActions from '../../actions/posts';
import CommentActions from '../../actions/comments';
import Avatar from './avatar';
import Controls from './post/controls';
import EditForm from './post/edit_form';
import Comment from './post/comment';
import CreateForm from './post/create_form';

class Post extends React.Component {
  constructor(props) {
    super(props);
    this.state = {editing: false};
  }

  _handleEdit(e) {
    e.preventDefault();
    this.setState({editing: true});
  }

  _handleEditSubmit(text) {
    const {dispatch, post} = this.props;
    dispatch(PostActions.edit(post, text));
  }

  _handleEditDone() {
    this.setState({editing: false});
  }

  _handleDelete(e) {
    e.preventDefault();
    this.props.dispatch(PostActions.delete(this.props.post));
  }

  _handleCommentSubmit(text) {
    const {dispatch, post} = this.props;
    dispatch(CommentActions.create(post, text));
  }

  _renderContent() {
    if (this.state.editing) {
      return (
        <EditForm
          className="post-edit-form"
          text={this.props.post.text}
          onSubmit={::this._handleEditSubmit}
          onDone={::this._handleEditDone} />
      );
    } else {
      return <article>{nl2br(this.props.post.text)}</article>;
    }
  }

  _renderComments() {
    const {post, currentUser} = this.props;
    if (!post.comments || post.comments.size === 0) return false;

    const comments = post.comments.map(comment =>
      <Comment
        key={`comment_${comment.id}`}
        comment={comment}
        editable={currentUser.id === comment.author.id}
        deletable={[comment.author.id, post.user_id].includes(currentUser.id)}/>
    );

    return <ul className="list-unstyled comments-list">{comments}</ul>;
  }

  render() {
    const {post, editable, deletable} = this.props;
    const date = new Date(post.inserted_at).toLocaleString();
    const onEdit = editable ? ::this._handleEdit : false;
    const onDelete = deletable ? ::this._handleDelete : false;

    return (
      <li key={`post_${post.id}`} data-post-id={post.id} style={{marginBottom: '1em'}}>
        <div className="list-group-item">
          <div>
            <div className="pull-left" style={{marginRight: '0.5em'}}>
              <Avatar
                user={post.author}
                version="thumb"
                className="img-responsive img-circle"/>
            </div>

            <strong>{post.author.first_name} {post.author.last_name}</strong>
          </div>

          <div>
            <time dateTime={post.inserted_at} className="small text-muted">
              {date}
            </time>

            <Controls onEdit={onEdit} onDelete={onDelete} />
          </div>

          <div className="clearfix" style={{marginBottom: '0.5em'}}/>
          {this._renderContent()}
        </div>

        <div className="list-group-item" style={{paddingLeft: '2em'}}>
          {this._renderComments()}

          <div className="comment-form" style={{marginTop: '1em'}}>
            <CreateForm
              post={post}
              onSubmit={::this._handleCommentSubmit}
              placeholder="Add comment"/>
          </div>
        </div>
      </li>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.currentUser
});

export default connect(mapStateToProps)(Post);
