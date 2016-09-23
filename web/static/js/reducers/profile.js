import Constants from '../constants';

const initialState = {
  user: null
};

export default function reducer(state = initialState, action = {}) {
  switch (action.type) {
    case Constants.USER_FETCHED:
      return {...state, user: action.user};

    case Constants.USER_FETCH_FAILURE:
      return initialState;

    case Constants.USER_ADDED_TO_FRIENDS:
    case Constants.USER_REMOVED_FROM_FRIENDS:
      if (state.user.id !== action.back_friendship.id) return state;

      let friends =
        state.user.friends
          .filter(friend => friend.id !== action.friendship.id);

      if (action.friendship.friendship_state == "confirmed") {
        friends = friends.concat(action.friendship);
      }

      return {...state, user: {...state.user, friends: friends}};

    default:
      return state;
  }
}
