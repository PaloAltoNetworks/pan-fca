export const config = {
  TERRAFORM_MODULE_DIR: './modules/azure',
  fw_count_options: [
    {name: 1, value: 1},
    {name: 2, value: 2},
    {name: 3, value: 3}
  ],
  fw_sizes: [
    {name: 'Standard_D3_v2', value: 'Standard_D3_v2'}
  ],
  vnet_peers: [
    {name: 1, value: 1},
    {name: 2, value: 2},
    {name: 3, value: 3}
  ],
  availability_option: [
    {name: 'availability_zone', value: 'availability_zone'},
    {name: 'availability_sets', value: 'availability_sets'},
  ],
  projectType: [
    {name: 'Greenfield', value: 'Greenfield'},
    {name: 'Brownfield', value: 'Brownfield'},
  ]
}