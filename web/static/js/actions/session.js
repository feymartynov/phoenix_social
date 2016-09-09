import {push} from 'react-router-redux';
import Constants from '../constants';
import {httpGet, httpPost, httpDelete} from '../utils';

function setCurrentUser(dispatch, user) {
  dispatch({
    type: Constants.SET_CURRENT_USER,
    user: user
  });
}

const Actions = {
  signIn: (sessionData) => {
    return dispatch => {
      httpPost('/api/v1/session', {session: sessionData})
        .then(data => {
          localStorage.setItem(Constants.AUTH_TOKEN_KEY, data.jwt);
          setCurrentUser(dispatch, data.user);
          dispatch(push('/'));
        })
        .catch(error => {
          error.response.json()
            .then(json => {
              dispatch({
                type: Constants.SIGN_IN_ERROR,
                error: json.error
              });
            });
        });
    };
  },
  signUp: userData => {
    return dispatch => {
      httpPost('/api/v1/user', {user: userData})
        .then(data => {
          localStorage.setItem(Constants.AUTH_TOKEN_KEY, data.jwt);
          setCurrentUser(dispatch, data.user);
          dispatch(push('/'));
        })
        .catch(error => {
          error.response.json()
            .then(json => {
              dispatch({
                type: Constants.SIGN_UP_ERRORS,
                errors: json.errors
              });
            });
        });
    };
  },
  signOut: () => {
    return dispatch => {
      httpDelete('/api/v1/session')
        .then(() => {
          localStorage.removeItem(Constants.AUTH_TOKEN_KEY);
          dispatch(push('/sign_in'));
          dispatch({type: Constants.USER_SIGNED_OUT});
        })
        .catch(error => console.error(error));
    };
  },
  fetchCurrentUser: () => {
    return dispatch => {
      httpGet('/api/v1/user')
        .then(data => setCurrentUser(dispatch, data.user))
        .catch(error => console.error(error));
    };
  }
};

export default Actions;
