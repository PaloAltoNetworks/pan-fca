const router = require('express').Router();

const Terraform = require('../controllers/terraform.js');
const Project = require('../controllers/project.js');

// GET
router.get('/project/:id', Project.get);
router.get('/terraform/:id', Terraform.get);

// POST
router.post('/terraform/init/:id', Terraform.init);
router.post('/terraform/plan/:id', Terraform.plan);
router.post('/terraform/apply/:id', Terraform.apply);
router.post('/project', Project.create);

// UPDATE
router.put('/project/:id', Project.update);

// DELETE
router.delete('/project/:id', Project.delete);

module.exports = router;
