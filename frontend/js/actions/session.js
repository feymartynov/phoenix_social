import {push} from 'react-router-redux';
import Constants from '../constants';
import {httpGet, httpPost, httpDelete, handleFetchError} from '../utils';

function setCurrentUser(dispatch, user) {
  return dispatch({
    type: Constants.USER_FETCHED,
    current: true,
    user
  });
}

const Actions = {
  signIn: (sessionData) => {
    return dispatch => {
      return httpPost('/api/v1/session', {session: sessionData})
        .then(data => {
          localStorage.setItem(Constants.AUTH_TOKEN_KEY, data.jwt);
          setCurrentUser(dispatch, data.user);
          dispatch(push('/'));
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  signUp: userData => {
    return dispatch => {
      return httpPost('/api/v1/users', {user: userData})
        .then(data => {
          localStorage.setItem(Constants.AUTH_TOKEN_KEY, data.jwt);
          setCurrentUser(dispatch, data.user);
          dispatch(push(`/user${data.user.id}`));
        })
        .catch(error => {
          if (!error.response) throw error;

          error.response.json()
            .then(json => {
              dispatch({
                type: Constants.SIGN_UP_FAILURE,
                errors: json.errors
              });
            });
        });
    };
  },
  signOut: () => {
    return dispatch => {
      return httpDelete('/api/v1/session')
        .then(() => {
          localStorage.removeItem(Constants.AUTH_TOKEN_KEY);
          dispatch(push('/sign_in'));
          dispatch({type: Constants.USER_SIGNED_OUT});
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  fetchCurrentUser: () => {
    return dispatch => {
      return httpGet('/api/v1/users/current')
        .then(data => setCurrentUser(dispatch, data.user))
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
