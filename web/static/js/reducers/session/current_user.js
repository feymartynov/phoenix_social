import Constants from '../../constants';

function addFriend(friends, friendship) {
  return removeFriend(friends, friendship).concat(friendship);
}

function removeFriend(friends, friendship) {
  return friends.filter(friend => friend.id !== friendship.id);
}

export default function reducer(state = null, action = {}) {
  if (state === null) return null;

  switch (action.type) {
    case Constants.USER_ADDED_TO_FRIENDS:
      return {...state, friends: addFriend(state.friends, action.friendship)};

    case Constants.USER_REMOVED_FROM_FRIENDS:
      return {...state, friends: removeFriend(state.friends, action.friendship)};

    default:
      return state;
  }
}
