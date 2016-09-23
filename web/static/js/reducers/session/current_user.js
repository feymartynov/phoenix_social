import Constants from '../../constants';


export default function reducer(state = null, action = {}) {
  if (state === null) return null;

  switch (action.type) {
    case Constants.USER_ADDED_TO_FRIENDS:
    case Constants.USER_REMOVED_FROM_FRIENDS:
      if (state.id !== action.back_friendship.id) return state;

      const friends =
        state.friends
          .filter(friend => friend.id !== action.friendship.id)
          .concat(action.friendship);

      return {...state, friends: friends};

    default:
      return state;
  }
}
