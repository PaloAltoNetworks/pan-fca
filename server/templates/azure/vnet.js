const _ = require('lodash');
const { ifVarExist } = require('../helper');

const vnet = (vnets, location, modules_dir) => {

  return _.map(vnets, (vnet, name) => {
    // console.log(JSON.stringify(vnet))
    // console.log(vnet['vnet_network'].subnet)
    
    const rg_name = vnet['vnet_network']['resource_group_name']? vnet['vnet_network']['resource_group_name']: name;
    return `
module "${name}" {
  source                  = "${modules_dir}/vnet"
  resource_group_name     = "${rg_name}"
  location                = "${location}"
  vnet_name               = "${vnet['vnet_network']['name']}"
  address_space           = "${vnet['vnet_network']['network']}"
  subnet_prefixes         = [${vnet['vnet_network'].subnet.map(a => `"${a.network}"`)}]
  subnet_names            = [${vnet['vnet_network'].subnet.map(a => `"${a.name}"`)}]



}`
  })
}

/*
  tags = {
    ${_.map(vnet.tags, tag => [tag.name] = `"${tag.value}"`)}
  }
*/
module.exports = vnet
