const Constants = {
  // Errors
  ERROR_RAISED: 'ERROR_RAISED',
  ERROR_DISMISSED: 'ERROR_DISMISSED',

  // Session
  AUTH_TOKEN_KEY: 'phoenixSocialAuthToken',
  SIGN_UP_FAILURE: 'SIGN_UP_FAILURE',

  // Current user
  CURRENT_USER_FETCHED: 'CURRENT_USER_FETCHED',
  CURRENT_USER_RESET: 'CURRENT_USER_RESET',
  USER_ADDED_TO_FRIENDS: 'USER_ADDED_TO_FRIENDS',
  USER_REMOVED_FROM_FRIENDS: 'USER_REMOVED_FROM_FRIENDS',

  // Socket
  SOCKET_CONNECTED: 'SOCKET_CONNECTED',

  // Presence
  PRESENCE_CHANNEL_CONNECTED: 'PRESENCE_CHANNEL_CONNECTED',
  PRESENCE_CHANNEL_DISCONNECTED: 'PRESENCE_CHANNEL_DISCONNECTED',
  PRESENCE_STATE_RECEIVED: 'PRESENCE_STATE_RECEIVED',
  PRESENCE_DIFF_RECEIVED: 'PRESENCE_DIFF_RECEIVED',

  // Profile
  PROFILE_FETCHED: 'PROFILE_FETCHED',
  PROFILE_RESET: 'PROFILE_RESET',
  PROFILE_FIELDS: {
    birthday: 'Date of birth',
    gender: 'Gender',
    marital_status: 'Marital status',
    city: 'City',
    languages: 'Languages',
    occupation: 'Occupation',
    interests: 'Interests',
    favourite_music: 'Favourite music',
    favourite_movies: 'Favourite movies',
    favourite_books: 'Favourite books',
    favourite_games: 'Favourite games',
    favourite_cites: 'Favourite cites',
    about: 'About self'
  },

  // Post
  POST_ADDED: 'POST_ADDED',
  POST_EDITED: 'POST_EDITED',
  POST_DELETED: 'POST_DELETED',

  // Comment
  COMMENT_ADDED: 'COMMENT_ADDED',
  COMMENT_EDITED: 'COMMENT_EDITED',
  COMMENT_DELETED: 'COMMENT_DELETED',

  // Wall
  WALL_FETCHED: 'WALL_FETCHED',
  WALL_CONNECTED_TO_CHANNEL: 'WALL_CONNECTED_TO_CHANNEL',
  WALL_RESET: 'WALL_RESET',

  // Feed
  FEED_FETCHED: 'FEED_FETCHED',
  FEED_CONNECTED_TO_CHANNEL: 'FEED_CONNECTED_TO_CHANNEL',
  FEED_RESET: 'FEED_RESET'
};

export default Constants;
