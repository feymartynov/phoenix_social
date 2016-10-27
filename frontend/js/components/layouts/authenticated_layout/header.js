import React from 'react';
import {connect} from 'react-redux';
import {Nav, NavItem, NavDropdown, MenuItem, Navbar} from 'react-bootstrap';
import {Link} from 'react-router';
import Actions from '../../../actions/session';

class Header extends React.Component {
  _handleSignOut(e) {
    e.preventDefault();
    this.props.dispatch(Actions.signOut());
  }

  render() {
    const {currentUser} = this.props;
    const username = [currentUser.first_name, currentUser.last_name].join(' ');

    return (
      <Navbar>
        <div className="container">
          <Navbar.Header>
            <Navbar.Brand>
              <Link to={'/user' + currentUser.id}>PhoenixSocial</Link>
            </Navbar.Brand>
            <Navbar.Toggle />
          </Navbar.Header>
          <Navbar.Collapse>
            <Nav pullRight>
              <NavDropdown title={username} id="user_menu">
                <MenuItem
                  href="#"
                  onClick={::this._handleSignOut}
                  id="sign_out_link">
                  Sign out
                </MenuItem>
              </NavDropdown>
            </Nav>
          </Navbar.Collapse>
        </div>
      </Navbar>
    );
  }
}

const mapStateToProps = state => ({
  currentUser: state.currentUser,
});

export default connect(mapStateToProps)(Header);
