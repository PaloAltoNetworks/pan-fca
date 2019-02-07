variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "terraform-compute"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "vnet_name" {
  description = "The vnet name of the virtual network where the virtual machines will reside."
  type        = "string"
  default     = ""
}
variable "subnet_name" {
  description = "The subnet to place the worker node on"
  type        = "string"
  default     = ""
}

variable "public_ip_dns" {
  description = "Optional globally unique per datacenter region domain name label to apply to each public ip address. e.g. thisvar.varlocation.cloudapp.azure.com where you specify only thisvar here. This is an array of names which will pair up sequentially to the number of public ips defined in var.nb_public_ip. One name or empty string is required for every public ip. If no public ip is desired, then set this to an array with a single empty string."
  type        = "list"
  default     = []
}

variable "ssh_key" {
  description = "Path to the private key to be used for ssh access to the VM.  Only used with non-Windows vms and can be left as-is even if using Windows vms. If specifying a path to a certification on a Windows machine to provision a linux vm use the / in the path versus backslash. e.g. c:/home/id_rsa.pub"
  type        = "string"
  default     = ""
}

variable "public_ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM.  Only used with non-Windows vms and can be left as-is even if using Windows vms. If specifying a path to a certification on a Windows machine to provision a linux vm use the / in the path versus backslash. e.g. c:/home/id_rsa.pub"
  type        = "string"
  default     = ""
}

variable "remote_port" {
  description = "Remote tcp port to be used for access to the vms created via the nsg applied to the nics."
  type        = "string"
  default     = "22"
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed"
  type        = "string"
  default     = "paloalto"
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  type        = "string"
  default     = "Standard_LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = "string"
  default     = "Standard_F2"
}

variable "nb_instances" {
  description = "Specify the number of vm instances"
  type        = "string"
  default     = "1"
}

variable "vm_hostname" {
  description = "local name of the VM"
  type        = "string"
  default     = "panwworkernode"
}

variable "vm_os_simple" {
  description = "Specify UbuntuServer, WindowsServer, RHEL, openSUSE-Leap, CentOS, Debian, CoreOS and SLES to get the latest image version of the specified os.  Do not provide this value if a custom value is used for vm_os_publisher, vm_os_offer, and vm_os_sku."
  type        = "string"
  default     = "UbuntuServer"
}

variable "vm_os_id" {
  description = "The resource ID of the image that you want to deploy if you are using a custom image.Note, need to provide is_windows_image = true for windows custom images."
  type        = "string"
  default     = ""
}

variable "is_windows_image" {
  description = "Boolean flag to notify when the custom image is windows based. Only used in conjunction with vm_os_id"
  type        = "string"
  default     = "false"
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = "string"
  default     = "Canonical"
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = "string"
  default     = "UbuntuServer"
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = "string"
  default     = "16.04-LTS"
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = "string"
  default     = "latest"
}

variable "tags" {
  type        = "map"
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}

variable "public_ip_address_allocation" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  type        = "string"
  default     = "dynamic"
}

variable "nb_public_ip" {
  description = "Number of public IPs to assign corresponding to one IP per vm. Set to 0 to not assign any public IP addresses."
  type        = "string"
  default     = "1"
}

variable "delete_os_disk_on_termination" {
  description = "Delete datadisk when machine is terminated"
  type        = "string"
  default     = "true"
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type"
  type        = "string"
  default     = "Standard_LRS"
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size"
  type        = "string"
  default     = ""
}

variable "data_disk" {
  type        = "string"
  description = "Set to true to add a datadisk."
  default     = "false"
}

variable "boot_diagnostics" {
  description = "(Optional) Enable or Disable boot diagnostics"
  type        = "string"
  default     = "false"
}

variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics"
  type        = "string"
  default     = "Standard_LRS"
}

variable "azurerm_client_id" {
  type        = "string"
  default     = ""
}

variable "azurerm_client_secret" {
  type        = "string"
  default     = ""
}

variable "azurerm_subscription_id" {
  type       = "string"
  default    = ""
}

variable "azurerm_tenant_id" {
  type       = "string"
  default    = ""
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  type        = "string"
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  type        = "string"
  default     = "LRS"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = ""
}

variable "starthub_tmp" {
  type        = "string"
  default     = "start-hub.sh"
}

variable "panorama_ip" {
  description = "Panorama IP Address to be passed to worker node configuration"
  type        = "string"
  default     = ""
}

variable "panorama_api_key" {
  description = "Panorama - VM Authorization KEY"
  type        = "string"
  default     = ""
}

variable "license_deactivation_key" {
  description = "Deactivation License key retrieved from customer support"
  type        = "string"
  default     = ""
}

variable "temp_stack" {
  description = "Panorama template stack name to monitor"
  type        = "string"
  default     = ""
}

variable "appinsights_name" {
  description = "Azure Application Insights Instance Name"
  type        = "string"
  default     = ""
}

variable "worker_name" {
  description = "Worker Node configuration name"
  type        = "string"
  default     = ""
}

variable "vmss_sa" {
  description = "VMSS SA node configuration"
  type        = "string"
  default     = ""
}

variable "vmss_sa_rg" {
  description = "VMSS SA RG node configuration"
  type        = "string"
  default     = ""
}

variable "scale_set_name" {
  description = "VMSS name to watch"
  type        = "string"
  default     = ""
}

variable "source_address_prefix" {
  description = "Source Address list for NSG"
  type        = "string"
  default     = ""
}