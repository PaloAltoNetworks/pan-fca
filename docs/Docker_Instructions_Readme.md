# FCA Container

Two versions of this container are included in this repository:

- `slim` container: Based on Alpine Linux
- `full` container: Based on Debian Linux

### System Requirements

- `Docker` v 18.0.6 or higher

### Image Resources

Both images have the following packages installed:

- Terraform v0.11.8
- Ansible v2.6.4
- pan-python
- pandevice
- xmltodict
- jsonschema
- python2.7
- pip

### Usage

#### Obtaining Container Image

> Pull container from Docker registry:

`docker pull dirtyonekanobi/ansible-terraform` _full image (500MB)_

`docker pull dirtyonekanobi/ansible-terraform-slim` _slim image (200MB)_

> Build from Dockerfile

`docker build -t <insert your tag name> -f Dockerfile-<full|slim> .`


#### Add Data

All data is contained within the `./root` directory

- Add Hub/Spokes data to the `./root/virtual_networks/<name>.yml`, with one `.yml` file per virtual network _see example files for details_
- Add the name of the Hub/Spoke to the `./root/group_vars/all.yml` file under `virtual_networks`
- Create a file called `provider.yml` _(see provider.example) for details_ that contains the `cloud_provider name`, `cloud_provider_location`, and appropriate credentials for the cloud provider

#### Launch Topology

- Start docker container and mount the root folder

`docker run -v ${PWD}:/fca -it dirtyonekanobi/ansible-terraform` _for full image_

`docker run -v ${PWD}:/fca -it dirtyonekanobi/ansible-terraform-slim` _for slim image_

`docker run -v ${PWD}:/fca -it <tag used in build step>` _for built image_

Adjusted command above since Root directory was removed.
This mounts the `./root` directory in the `fca` directory, and launches container

- Launch topology from within container image

`ansible playbook configuration_push.yml`

This will retrieve cloud provider information and credentials, create & run terraform plan, configure firewalls via Ansible, and save state file to the `./root` directory


