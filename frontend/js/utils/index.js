import React from 'react';
import fetch from 'isomorphic-fetch';
import {polyfill} from 'es6-promise';
import Constants from '../constants';
import ErrorActions from '../actions/error';

export function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  } else {
    var error = new Error(response.statusText);
    error.response = response;
    throw error;
  }
}

export function parseJSON(response) {
  return response.json();
}

const defaultHeaders = {
  Accept: 'application/json',
  'Content-Type': 'application/json'
};

export function httpFetch(url, options = {}) {
  const authToken = localStorage.getItem(Constants.AUTH_TOKEN_KEY);
  const headers = {...(options.headers || defaultHeaders), Authorization: authToken};

  return (
    fetch(url, {...options, headers: headers})
      .then(checkStatus)
      .then(parseJSON)
  );
}

export function httpGet(url) {
  return httpFetch(url, {method: 'get'});
}

export function httpPost(url, data) {
  return httpFetch(url, {method: 'post', body: JSON.stringify(data)});
}

export function httpPut(url, data) {
  return httpFetch(url, {method: 'put', body: JSON.stringify(data)});
}

export function httpDelete(url) {
  return httpFetch(url, {method: 'delete'});
}

export function handleFetchError(dispatch, error) {
  if (!error.response) throw error;

  error.response.json()
    .then(json => dispatch(ErrorActions.raise(json.error)))
    .catch(error =>
      console.error(
        "Failed to decode JSON error response from the server",
        error));
}

export function setDocumentTitle(title) {
  document.title = `${title} | Phoenix Social`;
}

export function reduceReducers(...reducers) {
  return (acc, current) => reducers.reduce((p, r) => r(p, current), acc);
}

export function nl2br(str) {
  const newlineRegex = /(\r\n|\n\r|\r|\n)/g;

  return str.split(newlineRegex).map(function (line, index) {
    if (line.match(newlineRegex)) {
      return React.createElement('br', {key: index});
    } else {
      return line;
    }
  });
}
