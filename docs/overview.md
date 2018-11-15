# Overview

The solution built is intended to be modular in design, and a good way to look at this is from the various persona's that will interact with the overall solution.

## As a User

The user needs to understand that they only need to describe their implementation via data structures, that adhere to the developed schema's. They simply need to gather credentials, understand the requirements, and translate those into the data structures.

Naturally not every potential solution will be supportable within the data model. The user can request to add the functionality, however, they should note that request come with a technical debt, and covering all use cases, will complicate all other use cases. Meaning, the data model may grow for fringe use cases the end solution would end up looking like the original solution (highly complex vendor specific data structures.)

Ultimately, once the data structures are filled out, the user simply needs to run a single Ansible Playbook that runs both Terraform and Ansible-pan modules for configuring the actual Panos device(s).

### Files

A user must have little familiarity with yaml and the way Ansible handle variables. They can always put all configurations into host vars, however, this will lead to duplication of data, and increase the chance of copy/paste induced errors.

Files that are in host_vars should be name `<fw>.yml`, e.g. `nyc-fw01.yml`. Ansible will by default take files labeled as such and add them to the variable management of the device. These files will override variables that applied to host_vars. Within host_vars, there is really only one group that you can use, since we are not managing inventory in a traditional Ansible sense. The file is called `all.yml`, which means it applies to any device.

There is a virtual_networks folder that has a file per virtual network (AWS VPC as an example.) This describes all of the cloud based infrastructure you are deploying.

## As a Developer

The developer needs to understand the user requirements and translate them into a data model. The data model is obviously just data, so it is the developer's responsibility to then create actions based on that data model. It is helpful exercise to simply worry about the data model first, ensure it fits the known use cases, and then develop the modularity to adhere to the background.

The core programmability for the developer is largely left unchanged, and the implications of being data driven are subtle, but can create new patterns. It is important to understand how the user will consume the service so that you can ensure you provide the proper context. 

# Components

There are several moving pieces that are used in this solution, it is important to keep them in mind as developing within the framework.

## Ansible

This serves as both the orchestration tool and Panos configuration elements. Since Ansible generally deploys in an idempotent method--meaning it can be run 1 or N times and only make 1 change--it fit There are many pieces to Ansible, and they will be covered in subsequent sections.

## Terraform

Terraform is able to deploy infrastructure in a declarative manner.  By describing the end-state, Terraform will compute the difference between the current state & target  end-state, and make the necessary configuration changes (within the respective cloud provider) to achieve this end-state.  For this data-driven implementation the developer needs to build logic to allow allow the infrastructure to grow dynamically, given the data provided

## TF Vars creation

The main.tf vars is not actually handcrafted as normally done in pure Terraform deployments, instead Ansible renders the files for you. This is covered in greater detail below

## Schema validation.

The schema validation is handled by an Ansible module. This provides a mechanism to validate the data structures against a pre-defined schema. Using an industry standard tool called json schema.

The definitions are built internally and stored in the folder called `schema_files`. Each file must be named the same as a root key in Ansible variables, and provided in the `scope` list of dictionaries, and currently in the role. 


Example Scope file:

```
scope:
  - name: "cm_virtual_router"
  - name: "cm_interface"
  - name: "cm_object_address"
  - name: "cm_object_address_group"
  - name: "cm_object_service"
  - name: "cm_object_service_group"
```
Example Schema Definition:

```
---
"$schema": http://json-schema.org/draft-04/schema#
description: The configuration options for PANOS Addresss Group Objects.
title: PANOS Address Group configuration
id: cm_object_address_group
type: array
items:
  type: object
  properties:
    name:
      description: Name of address group object
      type: string
      maxLength: 64
    addresses:
      description: List of address objects associated with group
      type: array
      items:
        description: Name of address objected already created
        type: string
  additionalProperties: false
  required:
    - "name"
    - "addresses"
additionalProperties: false
```

## Panos Configuration

Palo Alto maintains a set of Ansible module for configuring devices. Using the data model as a foundation, we configure the Ansible modules to build out the configuration. The level of support of the modules will also become tied together with the level of support with this solution.

## Ansible Roles

Ansible Roles are used as logical constructs to break up the "code" similar to how functions are used in a traditional programming language. This is mentioned simply to help a developer locate the actual Ansible plays being used.


## Testing

Jenkins was deployed, and relies on an active project to poll, and a Jenkinsfile to define the tests. At the time of this writing, the only tests being completed are ones to verify yaml linting. As with any testing, there are limitless amounts of tests that can be built.

## Docker

Docker is used to ensure there are no external configuration dependencies not met. This additionally ensures a consitent working environment regardless of location.

## Filter Plugins

Jinja has a concept of filter plugins, e.g. `| lower` is a filter. There are several custom filter plugins located in the project within the `filter_plugins`. 

## Custom Modules

Ansible comes built with many modules, but there are often use cases where you would need to extend that functionality. In this project they are located in the `library` folder

## Jinja Files

Ansible uses Jinja in many facets, one of the main ways it is used in this project is within the main.tf creation. The primary files is essentially a simple include to other files.

As an example, `azure-main.tf.j2`:
```
// Locking down version to get around lb_port issue
provider "azurerm" {
  version = "1.12"
}

{% include "azure-vnet.tf.j2" %}
{% include "azure-router.tf.j2" %}
{% include "azure-loadbalancer.tf.j2" %}
{% include "azure-firewall.tf.j2" %}
{% include "azure-peering.tf.j2" %}
```

# Anatomy of the configuration Push playbook

1. Obtain credentials

```
    - name: "SETUP CREDENTIALS & ENV FOR {{ cloud_provider| upper }}"
      include_role:
        name: "env_setup"
      tags:
        - 'always'
        - 'tf'
```

2. Create Vars from virtual networks folder, this essentially performs magic to flatten `schema_files` folder and perform schema validation on the variables.

```
    - name: "RUN ROLE TO MANAGE VARS AND SCHEMA VALIDATION"
      include_role:
        name: "var_management"
      tags:
        - 'always'
        - 'tf'
```

3. This calls a Jinja file, that create the main.tf file that is actually used by Ansible. The Jinja file is simple in nature, and simply includes other files that have more complex business logic.

```

    - name: "CREATING {{ cloud_provider }} TEMPLATE"
      template:
        src: "{{ cloud_provider }}-main.tf.j2"
        dest: "{{ output_file }}"
      tags:
        - 'always'
        - 'tf'
```
4. Run the traditional Terraform process
```
    - name: "RUN FMT FOR {{ cloud_provider }}"
      command: 'terraform fmt {{ output_file }}'
      tags:
        - 'tf'

    - name: "EXECUTE TERRAFORM PLAN"
      include_role:
        name: "terraform"
      tags:
        - 'always'
        - 'tf'
```

5. Since the firewalls were created dynamically, you must get them on the fly. These tasks do that, and add them to a group that get's run in the next play.

```

    - name: "GET CREATED FIREWALLS FROM TERRAFORM OUTPUT"
      command: 'terraform output -json firewalls_created'
      register: firewalls_created

    - name: "USE TERRAFORM OUTPUT STORE TEMP VALUES"
      set_fact:
        firewalls: "{{ firewalls_created.stdout |from_json }}"

    - name: "ADD HOSTS FROM TF OUTPUT TO FIREWALL GROUP"
      add_host:
        hostname: "{{ item.key }}"
        ansible_host: "{{ item.value }}"
        ansible_ssh_private_key: "{{ temp_key }}"
        groups: "firewalls"
      with_dict: "{{ firewalls['value'] }}"
      tags:
        - 'tf'

```

6. The play is ran against this new group

```

- name: "DEPLOY CONFIGURATIONS AND VALIDATE"
  hosts: "firewalls"
  connection: "local"
  gather_facts: "no"

  vars_files:
    - "{{ playbook_dir }}/provider.yml"

  vars:
    temp_key_dir: "{{ lookup('env', 'HOME') }}/paloalto/creds"
    temp_key: "{{ temp_key_dir }}/tempkey"

  tasks:
```


7. There are several management processes needed to get the device in ready to be configured

```
    - name: "WAIT FOR HTTPS ACCESS"
      wait_for:
        host: "{{ ansible_host }}"
        port: 443
        timeout: 300

    - name: "WAIT FOR MGMT AVAILABILITY"
      pause:
        seconds: 60

    - name: "CONFIGURE MGMT ACCESS"
      panos_admpwd:
        ip_address: "{{ ansible_host }}"
        key_filename: "{{ temp_key }}"
        username: "{{ username }}"
        newpassword: "{{ password }}"
      when: cloud_provider == 'aws'

```

8. Run the standard Palo Alto ansible modules, within the defined roles

```

    - name: "DEPLOY ANY LICENSES OR ADMIN TASKS"
      include_role:
        name: "pa_admin"
      tags:
        - 'ansible'

    - name: "PUSH ANY ZONE OR NETWORK CONFIGURATIONS"
      include_role:
        name: "pa_network"
      tags:
        - 'ansible'

    - name: "PUSH ANY OBJECTS"
      include_role:
        name: "pa_object"
      tags:
        - 'ansible'

    - name: "PUSH SECURITY RULES"
      include_role:
        name: "pa_srule"
      tags:
        - 'ansible'

    - name: "COMMIT THE CHANGES"
      panos_commit:
        ip_address: '{{ ansible_host }}'
        username: '{{ username }}'
        password: '{{ password }}'
      tags:
        - 'ansible'
```


# Important Files

| Name | Location | Function |
| --- | --- | --- |
| Configuration Push | configuration_push.yml | The orchestrator of the entire process |
| Schema Definitions | ./schema_files/* | Provides the schema defintions that the data structures are compared to |
| AWS Modules | ./modules/aws | The Terraform modules used in an AWS deployment |
| Azure Modules | ./modules/azure | The terraform modules used in an Azure deployment |
| Custom Anisble Modules | ./library/ | The custom built Ansible modules local to this instance |
| Host Variables | ./host_vars/ | The variables used by Ansible to applied to indivual devices |
| Group Variables | ./group_vars/ | The variables used by Ansible that are applied to all devices |
| Main TF Templates | ./templates | Here are the Jinja files that create the main.tf vars file |
| Dockerfile Files | ./Dockerfile* | There are both files for a full and slim instance to create a usable envirnment quickly |
| Jenkins | Jenkinsfile | Defines the tests that are run during each Jenkins testing suite |
| Provider | provider.yml | This is the file you will need to fill out with the local credentials, it is in the gitignore and an example file is given |

