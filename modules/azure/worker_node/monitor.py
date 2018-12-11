#!/usr/bin/python

import configparser
import logging
from logging.handlers import TimedRotatingFileHandler
import re
import ssl
import xml.etree.ElementTree as ET


import urllib2
import xmltodict
from azure.common import AzureMissingResourceHttpError
from azure.common.credentials import ServicePrincipalCredentials
from azure.cosmosdb.table import TableService
from azure.cosmosdb.table.models import Entity
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.storage import StorageManagementClient

LOG_FILENAME = 'worker.log'
CRED_FILE = 'monitor.cfg'
logHandler = TimedRotatingFileHandler(LOG_FILENAME, when="midnight")
logFormatter = logging.Formatter('%(asctime)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
logHandler.setFormatter(logFormatter)

logger = logging.getLogger('time_rotate_logger')
logger.addHandler(logHandler)
logger.setLevel(logging.DEBUG)

# logging.basicConfig(filename=LOG_FILENAME, level=logging.INFO,
#                     filemode='a',
#                     format='[%(asctime)s] [%(levelname)s] (%(threadName)-10s) %(message)s')
# logger = logging.getLogger(__name__)
# logger.setLevel(logging.INFO)


#####################
# Utility functions #
#####################

from logging.handlers import TimedRotatingFileHandler




def get_default_ssl_context():
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    return ctx


def get_azure_cred():
    config = configparser.ConfigParser()
    config.read(CRED_FILE)
    test = config['DEFAULT']['azure_client_id']
    subscription_id = str(config['DEFAULT']['azure_subscription_id'])
    credentials = ServicePrincipalCredentials(
        client_id=config['DEFAULT']['azure_client_id'],
        secret=config['DEFAULT']['azure_client_secret'],
        tenant=config['DEFAULT']['azure_tenant_id']
    )
    return credentials, subscription_id

def get_storage_acct_values():
    config = configparser.ConfigParser()
    config.read(CRED_FILE)
    return (str(config['DEFAULT']['STORAGE_ACCT_NAME'])),(str(config['DEFAULT']['STORAGE_ACCT_RG']))

def get_worker_name():
    config = configparser.ConfigParser()
    config.read(CRED_FILE)
    return (str(config['DEFAULT']['WORKER_NAME']))

def get_vmss_rg():
    config = configparser.ConfigParser()
    config.read(CRED_FILE)
    return (str(config['DEFAULT']['RG_NAME']))


def get_vmss_name():
    config = configparser.ConfigParser()
    config.read(CRED_FILE)
    return (str(config['DEFAULT']['VMSS_NAME']))


def get_vmssrg_and_storage_name():
    config = configparser.ConfigParser()
    config.read(CRED_FILE)
    return (str(config['DEFAULT']['RG_NAME']))


def get_panorama():
    config = configparser.ConfigParser()
    config.read(CRED_FILE)

    panorama_ip = str(config['DEFAULT']['PANORAMA_IP'])
    panorama_key = str(config['DEFAULT']['PANORAMA_API_KEY'])
    return (panorama_ip, panorama_key)


class Panorama:
    ILB_NAT_OBJ_NAME = 'ILB_NAT_ADDR'

    def __init__(self, ip, key, logger):
        self.ip = ip
        self.key = key
        self.logger = logger

    def execute_command(self, url, ret_dict=True):
        ctx = get_default_ssl_context()
        self.logger.info("Executed URL %s" % url)
        try:
            req = urllib2.Request(url)
            response = urllib2.urlopen(req, context=ctx)
            xml_resp = response.read()

            # If you want to return the response as xml.
            if not ret_dict:
                return True, ET.fromstring(xml_resp)

            o = xmltodict.parse(xml_resp, force_list=['entry'])
        except Exception as e:
            self.logger.error('Execution of cmd failed with %s' % str(e))
            return (False, str(e))

        if o['response']['@status'].lower() == 'success':
            if ('type=op' in url or
                    'type=commit' in url or
                    'action=get' in url):
                return (True, o['response']['result'])
            return (True, o['response']['msg'])
        else:
            return (False, o['response']['msg'])

    def get_dg_name_of_spoke(self, spoke):
        return spoke

    def get_tmplstk_name_of_spoke(self, spoke):
        config = configparser.ConfigParser()
        config.read(CRED_FILE)
        return (str(config['DEFAULT']['TMPL_STACK']))

    def set_ilb_nat_address(self, dg_name, nat_ip):
        url = "https://" + self.ip + "/api/?type=config&action=set&key=" + self.key
        url += "&xpath=/config/devices/entry[@name='localhost.localdomain']/"
        url += "device-group/entry[@name='" + dg_name + "']"
        url += "/address/entry[@name='" + self.ILB_NAT_OBJ_NAME + "']"
        url += "&element=<ip-netmask>" + nat_ip + "/32</ip-netmask>"
        ok, res = self.execute_command(url)
        if not ok:
            self.logger.info("Not able to set NAT Addr Obj %s in %s" % (nat_ip, dg_name))
            return ok, res
        self.logger.info("Successfully updated NAT Addr Obj %s in %s" % (nat_ip, dg_name))

        url = "https://" + self.ip + "/api/?type=commit&key=" + self.key
        url += "&cmd=<commit-all><device-group><name>"
        url += dg_name + "</name></device-group></commit-all>"
        ok, res = self.execute_command(url)
        if not ok:
            self.logger.info("Committing changes to DG %s failed" % dg_name)
        else:
            self.logger.info("Committing changes to DG %s successful" % dg_name)
        return ok, res

    def set_azure_advanced_metrics(self, templ_name, instr_key, enable=True):
        enable_str = "yes" if enable else "no"
        url = "https://" + self.ip + "/api/?type=config&action=set&key=" + self.key
        url += "&xpath=/config/devices/entry[@name='localhost.localdomain']/"
        url += "template/entry[@name='" + templ_name + "']"
        url += "/config/devices/entry[@name='localhost.localdomain']"
        url += "/deviceconfig/setting/azure-advanced-metrics"
        url += "&element=<enable>" + enable_str + "</enable>"
        ok, res = self.execute_command(url)
        if not ok:
            self.logger.info("Not able to enable Azure CW Metrics in %s" % templ_name)
            return ok, res
        self.logger.info("Successfully enabled Azure CW Metrics in %s" % templ_name)

        url = "https://" + self.ip + "/api/?type=config&action=set&key=" + self.key
        url += "&xpath=/config/devices/entry[@name='localhost.localdomain']/"
        url += "template/entry[@name='" + templ_name + "']"
        url += "/config/devices/entry[@name='localhost.localdomain']"
        url += "/deviceconfig/setting/azure-advanced-metrics"
        url += "&element=<instrumentation-key>" + instr_key + "</instrumentation-key>"
        ok, res = self.execute_command(url)
        if not ok:
            self.logger.info("Not able to set InstrKey in %s" % templ_name)
            return ok, res
        self.logger.info("Successfully added InstrKey %s in %s" % (instr_key, templ_name))

        url = "https://" + self.ip + "/api/?type=commit&key=" + self.key
        # Commit the changes to the template in Panorama
        url += "&cmd=<commit-all><template><name>"
        url += templ_name + "</name></template></commit-all>"
        ok, res = self.execute_command(url)
        return ok, res

    def get_devices_in_dg(self, dg_name):
        url = "https://" + self.ip + "/api/?type=config&action=get&key=" + self.key
        url += "&xpath=/config/devices/entry[@name='localhost.localdomain']/"
        url += "device-group/entry[@name='" + dg_name + "']/devices"
        ok, result = self.execute_command(url, ret_dict=True)
        if not ok:
            self.logger.info("Getting device list from DG %s failed %s" % (dg_name, result))
            return ok, result

        device_list_in_dg = []
        if result.get('devices', None):
            device_list_in_dg = [x['@name'] for x in result['devices'].get('entry', [])]

        # Bug in Panorama does not let to specify a specific device group
        # to query a specific Device Group. Have to look at all Devices
        # and filter.
        url = "https://" + self.ip + "/api/?type=op&key=" + self.key
        url += "&cmd=<show><devices><all>"
        url += "</all></devices></show>"
        ok, result = self.execute_command(url)

        # Get devices which were known to be in the given DG.
        device_list = []
        if result.get('devices', None):
            for device in device_list_in_dg:
                for global_device in result['devices'].get('entry', []):
                    if device == global_device['@name']:
                        device_list.append({
                            'name': global_device['@name'],
                            'hostname': global_device['hostname'],
                            'serial': global_device['serial'],
                            'ip-address': global_device['ip-address'],
                            'connected': global_device['connected'],
                            'deactivated': global_device['deactivated']
                        })
        return ok, device_list

    # /api/?type=op&cmd=<request><batch><license><info></info></license></batch></request>
    def get_valid_device_license_info(self, dg_name, devices):
        url = "https://" + self.ip + "/api/?type=op&key=" + self.key
        url += "&cmd=<request><batch><license><info>"
        url += "</info></license></batch></request>"
        ok, result = self.execute_command(url)
        if not ok:
            return False, result

        # No valid licenses in Panorama
        if not result['devices'].get('entry', None):
            return True, []

        hostnames = [x.get('hostname') for x in devices]
        valid_lics = [x.get('devicename') for x in result['devices']['entry'] \
                      if x.get('devicename') in hostnames]

        return True, valid_lics

    # <request><batch><license><deactivate><VM-Capacity><mode>auto</mode>
    # <devices>007057000043278</devices></VM-Capacity></deactivate></license></batch></request>
    def deactivate_license(self, serial_no):
        url = "https://" + self.ip + "/api/?type=op&key=" + self.key
        url += "&cmd=<request><batch><license><deactivate><VM-Capacity>"
        url += "<mode>auto</mode>"
        url += "<devices>" + serial_no + "</devices>"
        url += "</VM-Capacity></deactivate></license></batch></request>"
        ok, result = self.execute_command(url)
        if not ok:
            self.logger.error('Deactivation of VM with serial %s failed' % serial_no)
            return False, result
        return True, result

    def remove_device_from_dg(self, dg_name, device_name):
        url = "https://" + self.ip + "/api/?type=config&action=delete&key=" + self.key
        url += "&xpath=/config/devices/entry[@name='localhost.localdomain']"
        url += "/device-group/entry[@name='" + dg_name + "']/devices"
        url += "/entry[@name='" + device_name + "']"
        ok, result = self.execute_command(url)
        return ok, result

    def remove_device_from_template_stack(self, tmplstk_name, device_name):
        url = "https://" + self.ip + "/api/?type=config&action=delete&key=" + self.key
        url += "&xpath=/config/devices/entry[@name='localhost.localdomain']"
        url += "/template-stack/entry[@name='" + tmplstk_name + "']/devices"
        url += "/entry[@name='" + device_name + "']"
        ok, result = self.execute_command(url)
        return ok, result

    def remove_device_from_managed_devices(self, device_name):
        url = "https://" + self.ip + "/api/?type=config&action=delete&key=" + self.key
        url += "&xpath=/config/mgt-config/devices"
        url += "/entry[@name='" + device_name + "']"
        ok, result = self.execute_command(url)
        return ok, result

    # We have to de-link the device from the device group and template stack
    # manually so that the device can be removed the managed devices summary.
    # This is a best effort operation.
    def cleanup_device(self, dg_name, tmplstk_name, device_name):
        ok, res = self.remove_device_from_dg(dg_name, device_name)
        if not ok:
            self.logger.info('VM %s cannot be removed from DG %s in Panorama' % (device_name, dg_name))

        ok, res = self.remove_device_from_template_stack(tmplstk_name, device_name)
        if not ok:
            self.logger.info('VM %s cannot be removed from Template Stack %s in Panorama' % (device_name, tmplstk_name))

        ok, res = self.remove_device_from_managed_devices(device_name)
        if not ok:
            self.logger.info('VM %s cannot be removed from Managed devices in Panorama' % device_name)


class Azure:
    # Tags used
    RG_RULE_PROGRAMMED_TAG = 'PANORAMA_PROGRAMMED'
    HUB_MANAGED_TAG = 'PanoramaManaged'

    # Resource types
    VMSS_TYPE = 'Microsoft.Compute/virtualMachineScaleSets'
    ILB_TYPE = 'Microsoft.Network/loadBalancers'
    APPINSIGHTS_TYPE = 'Microsoft.Insights/components'

    # Hardcoded names used for internal Azure resources
    ILB_NAME = 'myPrivateLB'
    ALPHANUM = r'[^A-Za-z0-9]+'

    def __init__(self, cred, subs_id, my_storage_rg, vmss_rg_name, vmss_name, storage, pan_handle, logger=None):
        self.credentials = cred
        self.subscription_id = subs_id
        self.logger = logger
        self.hub_name = vmss_rg_name
        self.storage_name = storage
        self.panorama_handler = pan_handle
        self.vmss_table_name = re.sub(self.ALPHANUM, '', vmss_name + 'vmsstable')
        self.vmss_rg_name = vmss_rg_name

        try:
            self.resource_client = ResourceManagementClient(cred, subs_id)
            self.compute_client = ComputeManagementClient(cred, subs_id)
            self.network_client = NetworkManagementClient(cred, subs_id)
            self.store_client = StorageManagementClient(cred, subs_id)
            store_keys = self.store_client.storage_accounts.list_keys(my_storage_rg, storage).keys[0].value
            self.table_service = TableService(account_name=storage,
                                              account_key=store_keys)
        except Exception as e:
            self.logger.error("Getting Azure Infra handlers failed %s" % str(e))
            raise e


        rg_list = self.resource_client.resource_groups.list()
        self.managed_spokes = []
        self.managed_spokes.append(vmss_rg_name)
        self.new_spokes = []


    def filter_vmss(self, spoke, vmss_name):
        vmss = self.compute_client.virtual_machine_scale_sets.get(spoke, vmss_name)
        if vmss.tags and vmss.tags.get(self.HUB_MANAGED_TAG, None) == self.hub_name:
            return True
        return False

    def create_worker_ready_tag(self, worker_name):
        self.compute_client.virtual_machines.create_or_update(
            self.vmss_rg,
            worker_name,
            {
                'location': self.resource_client.resource_groups.get(self.vmss_rg).location,
                'tags': {
                    'WORKER_READY': 'Yes'
                }
            }
        )

    def create_new_cosmos_table(self, table_name):
        # Create the Cosmos DB if it does not exist already
        if not self.table_service.exists(table_name):
            try:
                ok = self.table_service.create_table(table_name)
                if not ok:
                    self.logger.error('Creating VMSS table failed')
                    return False
                self.logger.info('VMSS Table %s created succesfully' % table_name)
            except Exception as e:
                self.logger.error('Creating VMSS table failed ' + str(e))
                return False
        return True

    def clear_cosmos_table(self, table_name):
        self.table_service.delete_table(table_name)

    def get_vmss_by_name(self, spoke, vmss_name):

        vmss_list = [x.name for x in self.resource_client.resources.list_by_resource_group(spoke)
                     if x.type == self.VMSS_TYPE and x.name == vmss_name]

        if vmss_list:
            return vmss_list[0]
        else:
            self.logger.error("No VMSS found in Resource Group %s" % spoke)
        return None

    def get_vmss_in_spoke(self, spoke):

        vmss_list = [x.name for x in self.resource_client.resources.list_by_resource_group(spoke)
                     if x.type == self.VMSS_TYPE and self.filter_vmss(spoke, x.name)]

        if vmss_list:
            return vmss_list[0]
        else:
            self.logger.error("No VMSS found in Resource Group %s" % spoke)
            return None

    def get_vms_in_vmss(self, spoke, vmss_name):

        return self.compute_client.virtual_machine_scale_set_vms.list(spoke, vmss_name)

    def get_vm_in_cosmos_db(self, spoke, vm_hostname):

        try:
            db_vm_info = self.table_service.get_entity(self.vmss_table_name,
                                                       spoke, vm_hostname)
        except AzureMissingResourceHttpError:
            self.logger.info("New VM %s found in spoke %s" % (vm_hostname, spoke))
            return None
        except Exception as e:
            self.logger.error("Querying for %s failed" % vm_hostname)
            return None
        else:
            # IF possible update status TODO
            self.logger.debug("VM %s is available in VMSS, Pan and DB" % (vm_hostname))

        return db_vm_info

    # 'name'       : global_device['@name'],
    # 'hostname'   : global_device['hostname'],
    # 'serial'     : global_device['serial'],
    # 'ip-address' : global_device['ip-address'],
    # 'connected'  : global_device['connected'],
    # 'deactivated': global_device['deactivated']
    def create_db_entity(self, spoke, vm_details):

        vm = Entity()

        # PartitionKey is nothing but the spoke name
        vm.PartitionKey = spoke
        # RowKey is nothing but the VM name itself.
        vm.RowKey = vm_details['hostname']
        vm.name = vm_details['name']
        vm.serial_no = vm_details['serial']
        vm.ip_addr = vm_details['ip-address']
        vm.connected = vm_details['connected']
        vm.deactivated = vm_details['deactivated']
        vm.subs_id = self.subscription_id
        vm.delicensed_on = 'not applicable'
        vm.is_delicensed = 'No'
        try:
            self.table_service.insert_entity(self.vmss_table_name, vm)
            self.logger.info("VM %s with serial no. %s in db" % (vm_details['hostname'], vm_details['serial']))
        except Exception as e:
            self.logger.info("Insert entry to db for %s failed with error %s" % (vm_details['hostname'], e))
            return False
        return True

    def get_fw_vms_in_cosmos_db(self, spoke=None):

        if spoke:
            filter_str = "PartitionKey eq '%s'" % spoke
        else:
            filter_str = None

        db_vms_list = self.table_service.query_entities(self.vmss_table_name, filter=filter_str)
        if spoke:
            db_hostname_list = [{'hostname': x.RowKey, 'serial': x.serial_no, 'name': x.name} \
                            for x in db_vms_list if x.PartitionKey == spoke]
            return db_hostname_list
        else:
            return db_vms_list

    def delete_vm_from_cosmos_db(self, spoke, vm_name):

        self.table_service.delete_entity(self.vmss_table_name, spoke, vm_name)


def main():
    #"Assume SKU is Byol"
    vm_license_sku = ''
    logger.info("Starting monitoring script")
    credentials, subscription_id = get_azure_cred()
    panorama_ip, panorama_key = get_panorama()
    my_vmssrg_name = get_vmssrg_and_storage_name()
    my_storage_name, my_storage_rg = get_storage_acct_values()

    worker_name = get_worker_name()
    vmss_rg_name = get_vmss_rg()
    vmss_name = get_vmss_name()

    panorama = Panorama(panorama_ip, panorama_key, logger)
    azure_handle = Azure(credentials, subscription_id,
                         my_storage_rg, vmss_rg_name, vmss_name, my_storage_name, panorama, logger)
    azure_handle.create_new_cosmos_table(azure_handle.vmss_table_name)

    # Another constraint! The DG in Panorama has to be named
    #     # as <spoke_name> + '-dg'

    dg_name = panorama.get_dg_name_of_spoke(vmss_name)
    tmplstk_name = panorama.get_tmplstk_name_of_spoke(vmss_name)

    # azure_handle.clear_cosmos_table(azure_handle.vmss_table_name)

    # In all the resource groups in the subscription, look for VMSS which
    # particpates in the monitor's licensing function.
    vmss_vms_list = []
    for spoke in azure_handle.managed_spokes:

        vmss = azure_handle.get_vmss_by_name(spoke, vmss_name)
        if not vmss:
            logger.error("No VMSS found in Resource Group %s" % spoke)
            continue

        # Get VM list in the Azure VMSS
        vmss_vm_list = azure_handle.get_vms_in_vmss(spoke, vmss)

        # Get VM List in the Panorama Device Group List
        ok, pan_vms_list = panorama.get_devices_in_dg(dg_name)
        if not ok:
            logger.info("Failed to get device list from Panorama")
            continue

        vmss_hostname_list = []
        for vm in vmss_vm_list:
            vm_hostname = vm.os_profile.as_dict()['computer_name']
            vmss_hostname_list.append(unicode(vm_hostname))

            vm_license_sku = vm.plan.as_dict()['name']
            logger.info("Got license SKU %s" % vm_license_sku)

            # If VM is found in VMSS but not in Panorama, it is probably booting
            # and has not yet joined the Panorama Device Group list. Skip the VM for now.
            try:
                index = next(i for i, x in enumerate(pan_vms_list) if x['hostname'] == vm_hostname)
            except StopIteration:
                logger.info("VM %s found in VMSS but not in Panorama. May be not yet booted." % vm_hostname)
                continue

            # If the VM is found in VMSS and in Panorama as well, look it up
            # in the Cosmos DB. If not found, add the Licensing information to the DB. 
            db_vm_info = azure_handle.get_vm_in_cosmos_db(spoke, vm_hostname)
            if not db_vm_info:
                # New VM detected. Create an entity in the DB.
                ok = azure_handle.create_db_entity(spoke, pan_vms_list[index])
                if not ok:
                    logger.info("Creating DB Entry for VM %s failed" % vm_hostname)

        # Now, get a list of FW VMs stored in the backend for a spoke.
        db_hostname_list = azure_handle.get_fw_vms_in_cosmos_db(spoke)
        logger.info("Got list of VMs from Cosmos." % db_hostname_list)

        # The list of FW VMs that need to be licensed are the ones which are
        # found in the DB but not in Azure VMSS. They are gone and need to be
        # delicensed.
        vms_to_delic = [x for x in db_hostname_list if x.get('hostname') not in vmss_hostname_list]


        if vms_to_delic:

            if vm_license_sku == 'byol':
                logger.info('The following VMs need to be delicensed %s' % vms_to_delic)
                ok, valid_licenses = panorama.get_valid_device_license_info(spoke, vms_to_delic)
                if len(valid_licenses) != len(vms_to_delic):
                    logger.info('Some license entries not found in Panorama.')
                    logger.info('Will still attempt to delicense them')

            for device in vms_to_delic:
                if vm_license_sku == 'byol':
                    ok, res = panorama.deactivate_license(device.get('serial'))
                    if not ok:
                        logger.error(
                            'Deactivation of VM %s failed with error %s. will retry' % (device.get('hostname'), res))
                        continue
                    logger.info('Deactivation of VM %s successful' % device.get('RowKey'))
                panorama.cleanup_device(dg_name, tmplstk_name, device.get('name'))
                # Delete the entry from the table service as well.
                azure_handle.delete_vm_from_cosmos_db(spoke, device.get('hostname'))

        else:
            logger.debug('No VMs need to be delicensed. No-op')


    return 0


if __name__ == "__main__":
    main()
