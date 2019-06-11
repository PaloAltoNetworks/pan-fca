const _ = require('lodash');
const { ifVarExist } = require('../helper');

module.exports = (vnets, location, modules_dir) => {
  return _.map(vnets, (vnet, name) => {
    return _.map(vnet.route_tables, (rt) => {
      return `
module "${name}-${rt.name}" {
  source                               = "${modules_dir}/router"
  location                             = "${location}"
  resource_group_name                  = "\${module.${name}.resource_group_name}"
  route_table_name                     = "${rt.name}"

  routes = [
    ${_.map(rt.routes, route=> {
      return `{
        name    = "${route.name}"
        cidr    = "${route.cidr}"
        gateway = "${route.gateway}"
        name    = "${route.name}"

        ${ifVarExist('next_hop_type', route.next_hop_type, route.next_hop_type)}
      }`
    })}
  ]
}`
      })
  })
}

