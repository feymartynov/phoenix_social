import React from 'react';
import fetch from 'isomorphic-fetch';
import {polyfill} from 'es6-promise';
import Constants from '../constants';

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

function httpFetch(url, options = {}) {
  const authToken = localStorage.getItem(Constants.AUTH_TOKEN_KEY);
  const headers = {...defaultHeaders, Authorization: authToken};

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

export function httpDelete(url) {
  return httpFetch(url, {method: 'delete'});
}

export function setDocumentTitle(title) {
  document.title = `${title} | Phoenix Social`;
}

export function reduceReducers(...reducers) {
  return (acc, current) => reducers.reduce((p, r) => r(p, current), acc);
}
