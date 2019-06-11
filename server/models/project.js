const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const projectSchema = new Schema({
	userId: { type: String, required: true  },
  projectType: { type: String, default: 'greenfield' }, //Greenfield or Brownfield
  location: { type: String, default: 'West US' },
  vnets: [ { 
              firewalls: [
                {
                  fwname: { type: String, required: false },
                  username: { type: String, required: true },
                  password: { type: String, required: true },
                  fwversion: { type: String, required: true },
                  fwsku: { type: String, required: true },
                  avsetname: { type: String, required: true },
                  fwvmsize: { type: String, required: true },
                  vmcount: { type: Number, required: true }
                }
              ],
              load_balancers: [
                {
                  name: { type: String, required: true },
                  type: { type: String, required: true },
                  lbrulename: { type: String, required: true },
                  backendname: { type: String, required: true },
                  frontendname: { type: String, required: true },
                  lbprobename: { type: String, required: true },
                  lbrulebackendport: { type: String, required: true },
                  lbrulefrontendport: { type: String, required: true },     
                  lbrulehealthprobeport: { type: String, required: true },
                  lbruleprotocol: { type: String, required: true }
                }
              ],
              security_groups: [
                {
                  name: { type: String, required: true },
                  priority: { type: Number, required: true },
                  action: { type: String, required: true },
                  direction: { type: String, required: true },
                  dstnetwork: { type: String, required: true },
                  dstport: { type: String, required: true },
                  srcip: { type: String, required: true },
                  srcport: { type: String, required: true },
                  protocol: { type: String, required: true }
                }
              ],
              vnet_network: {
                  name: { type: String, required: true },
                  network: { type: String, required: true },
                  peers: [
                    { type: String, required: true }
                  ],
                  subnet: [
                    {
                      name: { type: String, required: true },
                      network: { type: String, required: true }
                    }
                  ]
              },
              route_tables: [
                {
                  name: { type: String, required: true },
                  routes: [
                    {
                      name: { type: String, required: true },
                      cidr: { type: String, required: true },
                      gateway: { type: String, required: true }
                    }
                  ]
                }
              ]
         } ]
});

module.exports = mongoose.model('project', projectSchema);
