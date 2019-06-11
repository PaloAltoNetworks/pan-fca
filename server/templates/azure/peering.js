const _ = require('lodash');

module.exports = (vnets, location, modules_dir) => {
  return _.map(vnets, (vnet, name) => {
    return _.map(vnet['vnet_network']['peers'], (peer, index) => {
      return `
module "${name}_peer_${index}" {
  source                               = "${modules_dir}/peering"
  peer_name                            = "\${module.${peer}.vnet_name}"
  peer_name                            = "\${module.${peer}.vnet_name}"
  peer_resource_group_name             = "\${module.${peer}.resource_group_name}"
  peer_virtual_network_name            = "\${module.${peer}.vnet_name}"
  peer_remote_virtual_network_id       = "\${module.${peer}.vnet_id}"
}`
      })
  })
}