import React from 'react';
import { Router, Route, Switch } from 'react-router-dom';
import Header from './Header';
import Azure from './Azure';
import history from '../history';

const App = () => {
  return (
    <div className="ui container">
      <Router history={history}>
        <div>
          <Header />
          <Switch>
            <Route path="/" exact component={Azure} />
          </Switch>
        </div>
      </Router>
    </div>
  );
};

export default App;