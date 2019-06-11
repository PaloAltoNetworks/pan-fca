const express = require('express');
const path = require('path');
const logger = require('morgan');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const serverConfig = require('./server/serverConfig');
const cors = require('cors');
const cookieParser = require('cookie-parser');

// MongoDB Connection
mongoose.Promise = global.Promise;

var isConnectedBefore = false;
var connect = () => {
  mongoose.connect(serverConfig.mongoURL, serverConfig.mongoOptions);
};
connect();

mongoose.connection.on('error', function () {
  console.log('Could not connect to MongoDB');
});

mongoose.connection.on('disconnected', function () {
  console.log('Lost MongoDB connection...');
  if (!isConnectedBefore)
    setTimeout(function () {
      connect();
    }, 5000);
});

mongoose.connection.on('connected', function () {
  isConnectedBefore = true;
  console.log('Connection established to MongoDB');
});

mongoose.connection.on('reconnected', function () {
  console.log('Reconnected to MongoDB');
});

// Close the Mongoose connection, when receiving SIGINT
process.on('SIGINT', function () {
  mongoose.connection.close(function () {
    console.log('Force to close the MongoDB conection');
    process.exit(0);
  });
});

const app = express();

app.use(cors({ origin: 'http://localhost:3000' }));

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

console.log(app.get('env'));

// Define routes
const apiRouter = require('./server/routes/api');
app.use('/api', apiRouter);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  const err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function (err, req, res, next) {
    res.status(err.status || 500).json({
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function (err, req, res, next) {
  res.status(err.status || 500).json({
    message: err.message,
    error: {}
  });
});

module.exports = app;
