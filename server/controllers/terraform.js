const _ = require('lodash');
const Project = require('../models/project');
const Terraform = require('../models/terraform');
const Template = require('../templates/azure/index.js')
const { exec } = require('child_process');
var fs = require('fs');

/*
  projectId: mongoose.Schema.Types.ObjectId,
  createdDate: { type: Date, default: Date.now, required: true },
  tfStateType: { type: String }, //INFRA
  tfStage: { type: String, default: "INIT" }, //INIT, INPROGRESS, COMPLETED
  tfFile: { type: Buffer },
  tfStateFile: { type: Buffer }
*/
const tf_op = (action, dir, id, content) => {
  // Allowed actions = init, plan, apply
  return new Promise((resolve, reject) => {
    Terraform.findOneAndUpdate(
      { projectId: id },
      { $set: {
          projectId: id,
          tfStateType: 'INFRASTRUCTURE',
          tfStage: 'INIT',
          tfFile: Buffer.from(content, 'utf8')
        }
      },
      { upsert: true, new: true }
    )
    .then(res => {
      exec(`terraform ${action} ${dir}`, (err, stdout, stderr) => {
        console.log(stdout, stderr)
        err ? reject(err) : (stderr) ? reject({msg : 'TERRAFORM INIT FAILED'}) : resolve({ id: res._id, msg : 'TERRAFORM INIT COMPLETED'})
        return
      })
    })
  })
}

const update_tf_document = (id, body) => {
  return Terraform.findOneAndUpdate(
    { projectId: id },
    { $set: body},
    { upsert: true, new: true }
  )
}

const create_file = (dir, content) => {
  if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
  }
  return new Promise((resolve, reject) => {
    fs.writeFile(`${dir}/main.tf`, content, 'utf8', (err) => {
      err ? reject(err) : resolve(dir)
      return
    })
  })
}

module.exports = {

  init: (req, res, next) => {
    const dir = `./tmp/${req.params.id}`;
    let mainTF = null
    Project.find({ _id: req.params.id })
    .then(result => {
      // Workaround to getrid of the in-built mongo functions before _.mapKeys
      const _tmp = JSON.parse(JSON.stringify(result[0].vnets))
      const vnets = _.mapKeys(_tmp, obj => obj.vnet_network.peers[0])

      // Generate tf file
      mainTF = Template.template(vnets, result[0].location)
      //console.log(mainTF)
      return create_file(dir, mainTF)
    })
    .then (tf_dir => tf_op('init', dir, req.params.id, mainTF))
    .then (msg => res.status(200).json(msg))
    .catch(err => next(err))
  },

  plan: function (req, res, next) {
    const dir = `./tmp/${req.params.id}`;

  },

  apply: function (req, res, next) {

    Project.find({ _id: req.params.id })
    .then(function (result) {
      const _tmp = JSON.parse(JSON.stringify(result[0].vnets))
      const vnets = _.mapKeys(_tmp, (obj) => {
        return obj.vnet_network.peers[0]
      })
      const location = result[0].location
      // Generate tf file
      const mainTF = Template.template(vnets, location)
      console.log(mainTF)
      
      


      fs.writeFile(`${dir}/main.tf`, mainTF, 'utf8', function(err) {
          if(err) {
            return next(err);
          }
          // Execute terraform
          exec(`terraform init ${dir}`, (error, stdout, stderr) => {
            if (error) {
              return next(err);
            }
            console.log(`stdout: ${stdout}`);
            console.log(`stderr: ${stderr}`);
            exec(`terraform apply ${dir}`, (error, stdout, stderr) => {
              if (error) {
                return next(err);
              }

              console.log(`stdout: ${stdout}`);
              console.log(`stderr: ${stderr}`);

              res.status(200).json(_tmp);
            })
          });


          
      }); 

      
    })
    .catch(function (err) {
      return next(err);
    });

    // execute tf init

    // execute tf apply

    // update tf document


    //res.status(200).json({terraform: 'apply'});
  },

  get: (req, res, next) => {
    Terraform.find({ _id: req.params.id })
    .then(function (result) {
      res.status(200).json(result[0]);
    })
    .catch(err => next(err))
  }
}


