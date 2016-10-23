import Constants from '../constants';
import {httpGet, handleFetchError} from '../utils';

const Actions = {
  fetchFeed: (offset = 0, limit = 20) => {
    return dispatch => {
      httpGet(`/api/v1/feed?offset=${offset}&limit=${limit}`)
        .then(json => {
          if (json.posts.length === 0) return;

          dispatch({
            type: Constants.FEED_FETCHED,
            posts: json.posts
          });
        })
        .catch(error => handleFetchError(dispatch, error));
    };
  }
};

export default Actions;
