import {
  SIGN_IN,
  SIGN_OUT,
  CREATE_PROJECT
} from './types';
import history from '../history';
import _ from 'lodash'
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:5000/api'
});

export const signIn = userId => {
  return {
    type: SIGN_IN,
    payload: userId
  };
};

export const signOut = () => {
  return {
    type: SIGN_OUT
  };
};


export const createProject = formValues => async (dispatch, getState) => {
    
    const { userId } = getState().auth;
    const projectType = getState().projectType;
    console.log(formValues)
    const response = await api.post('/project', { ...formValues, userId, projectType });
  
    dispatch({ type: CREATE_PROJECT, payload: response.data });
    //history.push('/');
  };