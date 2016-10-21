import Constants from '../constants';

const Actions = {
  raise: (error) => {
    return dispatch => {
      dispatch({type: Constants.ERROR_RAISED, error: error});
    };
  },
  dismiss: () => {
    return (dispatch, getState) => {
      if (!getState().error) return;
      dispatch({type: Constants.ERROR_DISMISSED});
    };
  }
};

export default Actions;
