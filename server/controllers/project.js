const _ = require('lodash');
const Project = require('../models/project');
const Terraform = require('../models/terraform');

module.exports = {

  get: (req, res, next) => {
    Project.find({ _id: req.params.id })
			.then(function (result) {
				res.status(200).json(result[0]);
			})
			.catch(err => next(err))
      
    //res.status(200).json({project: 'get'});
  },

  create: (req, res, next) => {
    const project = new Project(req.body);

    project.save()
    .then(function(data) {
      res.status(200).json(data);
    })
    .catch(err => next(err))

    //res.status(200).json({project: 'create'});
  },

  update: (req, res, next) => {
    console.log(req.params.id, )
    Project.findByIdAndUpdate(req.params.id, req.body, { new: true })
			.then(function (result) {
				res.status(200).json(result);
			})
			.catch(err => next(err))
      
    //res.status(200).json({project: 'update'});
  },

  delete: (req, res, next) => {
    Project.findByIdAndRemove(req.params.id)
			.then(function (result) {
        Terraform.remove({ projectId: result._id })
        .then(function (result) {
          res.status(200).json(req.params.id);
        })
			})
			.catch(err => next(err))
      
    //res.status(200).json({project: 'delete'});
  }
}

