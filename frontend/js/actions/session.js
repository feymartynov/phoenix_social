import {push} from 'react-router-redux';
import Constants from '../constants';
import {httpPost, httpDelete, handleFetchError} from '../utils';

function setCurrentUser(dispatch, data) {
  localStorage.setItem(Constants.AUTH_TOKEN_KEY, data.jwt);

  dispatch({
    type: Constants.CURRENT_USER_FETCHED,
    user: data.user
  });

  dispatch(push(`/${data.user.profile.slug}`));
}

const Actions = {
  signIn: (sessionData) => {
    return dispatch => {
      return httpPost('/api/v1/session', {session: sessionData})
        .then(data => setCurrentUser(dispatch, data))
        .catch(error => handleFetchError(dispatch, error));
    };
  },
  signUp: userData => {
    return dispatch => {
      return httpPost('/api/v1/users', {user: userData})
        .then(data => setCurrentUser(dispatch, data))
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
          dispatch({type: Constants.CURRENT_USER_RESET});
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
