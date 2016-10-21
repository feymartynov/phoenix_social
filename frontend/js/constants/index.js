const Constants = {
  // Errors
  ERROR_RAISED: 'ERROR_RAISED',
  ERROR_DISMISSED: 'ERROR_DISMISSED',

  // Session
  AUTH_TOKEN_KEY: 'phoenixSocialAuthToken',
  SIGN_UP_FAILURE: 'SIGN_UP_FAILURE',
  USER_SIGNED_OUT: 'USER_SIGNED_OUT',

  // Profile
  USER_FETCHED: 'USER_FETCHED',
  USER_FETCH_FAILURE: 'USER_FETCH_FAILURE',
  USER_ADDED_TO_FRIENDS: 'USER_ADDED_TO_FRIENDS',
  USER_REMOVED_FROM_FRIENDS: 'USER_REMOVED_FROM_FRIENDS',
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

  // Posts
  WALL_FETCHED: 'WALL_FETCHED',
  POST_CREATED: 'POST_CREATED',
  POST_UPDATED: 'POST_UPDATED',
  POST_DELETED: 'POST_DELETED'
};

export default Constants;