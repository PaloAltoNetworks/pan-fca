const _ = require('lodash');

// check_vars can be an array of varibales or a single variable 
// If all check_vars exist return (argument = value)
module.exports = {
  ifVarExist: (argument, check_vars, value) => {
    if (_.isArray(check_vars))
      return check_vars.every(cur_val => typeof variable !== 'undefined') ? `${argument} = ${value}` : ''
    else
      return (typeof variable !== 'undefined') ?  `${argument} = ${value}` : ''
  }
}

