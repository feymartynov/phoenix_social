import React from 'react';
import ReactDOM from 'react-dom';
import {connect} from 'react-redux';
import {Modal, Button, FormGroup, FormControl} from 'react-bootstrap';
import Actions from '../../../actions/avatar';

class AvatarUploader extends React.Component {
  constructor(props) {
    super(props);
    this.state = {showModal: false};
  }

  _close() {
    this.setState({showModal: false});
  }

  _open() {
    this.setState({showModal: true});
  }

  _handleUpload(e) {
    e.preventDefault();
    const {dispatch, profile} = this.props;
    const input = ReactDOM.findDOMNode(this.refs.avatar);
    if (!input.files[0]) return false;
    dispatch(Actions.uploadAvatar(profile, input.files[0]));
  }

  _handleRemove(e) {
    e.preventDefault();
    const {dispatch, profile} = this.props;
    dispatch(Actions.removeAvatar(profile));
  }

  render() {
    return (
      <div>
        <Button bsClass="btn-link" onClick={::this._open}>Change avatar</Button>

        <Modal show={this.state.showModal} onHide={::this._close}>
          <form onSubmit={::this._handleUpload}>
            <Modal.Header closeButton>
              <Modal.Title>Upload avatar</Modal.Title>
            </Modal.Header>
            <Modal.Body>
              <FormGroup>
                <label htmlFor="avatar">Choose an image to upload:</label>
                <FormControl
                  ref="avatar"
                  name="avatar"
                  type="file"
                  required="true" />
              </FormGroup>
            </Modal.Body>
            <Modal.Footer>
              <Button onClick={::this._close}>Cancel</Button>
              <Button onClick={::this._handleRemove} className="btn-danger">Remove</Button>
              <Button type="submit" className="btn-primary">Upload</Button>
            </Modal.Footer>
          </form>
        </Modal>
      </div>
    );
  }
}

const mapStateToProps = state => ({
  profile: state.currentProfile
});

export default connect(mapStateToProps)(AvatarUploader);
