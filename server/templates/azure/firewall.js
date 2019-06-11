const _ = require('lodash');
const { ifVarExist } = require('../helper');

module.exports = (vnets, location, modules_dir) => {

  return _.map(vnets, (vnet, name) => {
    const rg_name = vnet['vnet_network']['resource_group_name']? vnet['vnet_network']['resource_group_name']: name;
    return _.map(vnet.firewalls, fw => {
      
      return `
module "${fw.avsetname}" {
  source                      = "${modules_dir}/firewall"
  resource_group_name         = "${rg_name}"
  location                    = "${location}"
  nb_instances                = "${fw.vmcount}"
  ${ifVarExist('fwversion', fw.fwversion, fw.fwversion)}
  ${ifVarExist('fwsku', fw.fwsku, fw.fwsku)}
  ${ifVarExist('adminUsername', fw.username, fw.username)}
  ${ifVarExist('adminPassword', fw.password, fw.password)}
  ${ifVarExist('fw_dnshostname', fw.dnshostname, fw.dnshostname)}
  ${ifVarExist('lbnamepooltrust', fw.lbnamepooltrust, fw.lbnamepooltrust)}
  ${ifVarExist('lbnamepooluntrust', fw.lbnamepooluntrust, fw.lbnamepooluntrust)}
   
  vnet_subnet_id_mgmt         = "\${module.${name}.vnet_subnets[0]}"
  vnet_subnet_id_trust        = "\${module.${name}.vnet_subnets[1]}"
  vnet_subnet_id_untrust      = "\${module.${name}.vnet_subnets[2]}"

  fw_hostname                 = "${fw.fwname}"
  fw_size                     = "${fw.fwvmsize}"
  avsetname                   = "${fw.avsetname}"
}`
    })
  })
}