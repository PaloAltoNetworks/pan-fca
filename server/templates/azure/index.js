const _ = require('lodash');
const VNET = require("./vnet")
const LB = require("./loadbalancer")
const FW = require("./firewall")
const PEERING = require("./peering")
const ROUTER = require("./router")
const TESTHOST = require("../general/testHost")

const location = 'West US'
const fs = require('fs');

const TERRAFORM_MODULE_DIR = '../../core/modules/azure'



module.exports = {
  template: (vnets, location) => {
    const V = VNET(vnets, location, TERRAFORM_MODULE_DIR)
    //console.log(location)
    const L = LB(vnets, location, TERRAFORM_MODULE_DIR)[0]
    const fw = FW(vnets, location, TERRAFORM_MODULE_DIR)[0]
    const peer = PEERING(vnets, location, TERRAFORM_MODULE_DIR)[0]
    const router = ROUTER(vnets, location, TERRAFORM_MODULE_DIR)
    const testhost = TESTHOST(vnets, location, TERRAFORM_MODULE_DIR)
    
    const tf = _.concat(V, L, fw, peer, router, testhost)
    return tf.join('\n');
    // fs.writeFile("test.tf", tf.join('\n'), 'utf8', function(err) {
    //     if(err) {
    //         return console.log(err);
    //     }
    
    //     console.log("The file was saved!");
    // }); 
  }
}