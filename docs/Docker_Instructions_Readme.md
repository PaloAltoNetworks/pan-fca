# FCA Container

Two versions of this container are included in this repository:

- Dockerfile-FCA-slim `slim` container: Based on Alpine Linux
- Dockerfile-FCA `full` container: Based on Debian Linux


### System Requirements

- `Docker` v 18.0.9 or higher
-  `Docker Installation` To install Docker on your local operating system visit:
- Windows - https://docs.docker.com/docker-for-windows/install/
- Mac     - https://docs.docker.com/docker-for-mac/

### Image Resources

Both images have the following packages installed:

- Terraform v0.11.10
- Ansible v2.6.4
- pan-python
- paramiko (Galaxy Support)
- ipaddress (Galaxy Support)
- pandevice
- xmltodict
- jsonschema
- python2.7
- pip
- Ansible Role: PaloAltoNetworks.paloaltonetworks (FCA)
- Azure CLI (FCA)
- AWS CLI awscli
- Git-Core  For need to use Github for FCA demo


### Usage

#### Obtaining Container Image
Option #1

_**(Use this for Pre-built Container image)**_
> **Pull container from Docker registry:**

`docker pull panfca/tool:fca ` _full image (744MB)_

`docker pull panfca/tool:fca-slim` _slim image (500MB)_

#### Obtaining Container Image from GitHub
Option #2

`download the file Dockerfile-FCA`  _full image (744MB)_
`download the file Dockerfile-FCA-slim` _slim image (500MB)_

**Build from Dockerfile**

**Important Note Please Read!**

>You will need permissions to the:
 >https://github.com/PaloAltoNetworks/panos-fca upstream/master to download Dockerfile-FCA or Docker-FCA-slim files.  

**(You should already have this by Forking and Cloning upstream/master FCA Github repository. If not please contact administrator of Repo if not public!)**

**Now you will build from the Dockerfile located in repository.**

Full image build

`docker build -t <tag name> -f Dockerfile-FCA .`
 _Example:_ `docker build -t fca -f Dockerfile-FCA .`

Slim image build

`docker build -t <tag name> -f Dockerfile-FCA-slim .`
 _Example:_ `docker build -t fca -f Dockerfile-FCA-slim .`



#### Add Data

All data is contained within the `./root` directory

- Add Hub/Spokes data to the `./root/virtual_networks/<name>.yml`, with one `.yml` file per virtual network _see example files for details_
- Add the name of the Hub/Spoke to the `./root/group_vars/all.yml` file under `virtual_networks`
- Create a file called `provider.yml` _(see provider.example) for details_ that contains the `cloud_provider name`, `cloud_provider_location`, and appropriate credentials for the cloud provider

#### Launch Topology

Note:
If you want to create your own image name you can tag it with a custom tag.
> Example: `docker tag panfca/tool:fca myfca`

Then `docker images` to list your images.

Make sure you are in the root fca folder of the cloned repository or specify full path before mounting.

- **Start docker container and mount the root folder**

`docker run -v ${PWD}:/fca -it panfca/tool:fca` _for full image_

`docker run -v ${PWD}:/fca -it panfca/tool:fca-slim` _for slim image_

`docker run -v ${PWD}:/fca -it <tag used in build step>` _for built image_


This mounts the local `./fca` directory in the `fca` directory of the container, and launches container

Verify once container launches with `ls` then `cd` to `./fca` mounted directory 
once inside the container to run playbook commands.

**Note:** The topology will require manual intervention under the `.fca/virtual_networks` and `all.yml` in `fca/group_vars` folder
you then will see the example files for both and will need to be adjusted and renamed to `.yml` by removing
`.example` from the file extensions.


**_As further Mark phases of FCA project develop this manual intervention will not be needed and would be replaced by a Top level GUI interface that drives data input into a api layer._**


- **Launch topology from within container image.**

`ansible-playbook configuration_push.yml` This will launch the whole data driven playbook which combines all the group_vars variables for Firewall configurations as well as implement the custom virtual_networks/ topology.yml files you create specific to the cloud provider needs. 
`ansible-playbook destroy.yml` This command will destroy what was previously created from the `ansible-playbook configuration_push.yml` command.

This will retrieve cloud provider information and credentials, create & run terraform plan, configure firewalls via Ansible, and save state file to the `./fca` directory

After master playbook `configuration_push.yml` runs it will also generate a dynamic `main.tf` for cloud orchestration using the combination of `./virtual_networks/<insert custom name topology.yml>`
 and `./group_vars/all.yml` files with `provider.yml` cloud authentication credential variables to pull from the appropriate cloud orchestration terraform module resources.



**Removal of Docker images installed.**

`docker container stop $(docker container ls -a -q) && docker system prune -a -f --volumes`

Above command will destroy all docker containers and volumes if limited on space or running on a temporary bastion box scenario.

**Docker images are used to maintain code support version levels without the need to install on local machines.**