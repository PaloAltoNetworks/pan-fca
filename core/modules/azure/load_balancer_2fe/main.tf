# Azure load balancer module

resource "azurerm_lb" "azlb" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  tags                = "${var.tags}"
  sku                 = "${var.lbsku}"

  frontend_ip_configuration {
    name      = "${var.frontend_name[0]}"
    subnet_id = "${var.onprem_fe_id}"

    //    private_ip_address            = "${var.type == "private" ? "${var.frontend_private_ip_address}" : ""}"
    private_ip_address_allocation = "${var.frontend_private_ip_address_allocation}"
  }

  frontend_ip_configuration {
    name      = "${var.frontend_name[1]}"
    subnet_id = "${var.trust_fe_id}"

    //    private_ip_address            = "${var.type == "private" ? "${var.frontend_private_ip_address}" : ""}"
    private_ip_address_allocation = "${var.frontend_private_ip_address_allocation}"
  }
}

resource "azurerm_lb_backend_address_pool" "untrust_be" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.azlb.id}"
  name                = "${var.backendpoolname[0]}"
}

resource "azurerm_lb_backend_address_pool" "trust_be" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.azlb.id}"
  name                = "${var.backendpoolname[1]}"
}

resource "azurerm_lb_probe" "azlb" {
  count               = "${length(var.lb_port)}"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.azlb.id}"
  name                = "${var.lb_probename}"
  port                = "${element(var.lb_probe_port["${element(keys(var.lb_probe_port), count.index)}"], 0)}"
  interval_in_seconds = "${var.lb_probe_interval}"
  number_of_probes    = "${var.lb_probe_unhealthy_threshold}"
}

resource "azurerm_lb_rule" "untrust_lb_rule" {
  count                          = "${length(var.lb_port)}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.azlb.id}"
  name                           = "${element(keys(var.lb_port), count.index)}-untrust"
  protocol                       = "${element(var.lb_port["${element(keys(var.lb_port), count.index)}"], 1)}"
  frontend_port                  = "${element(var.lb_port["${element(keys(var.lb_port), count.index)}"], 0)}"
  backend_port                   = "${element(var.lb_port["${element(keys(var.lb_port), count.index)}"], 2)}"
  frontend_ip_configuration_name = "${var.frontend_name[0]}"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.untrust_be.id}"
  load_distribution              = "${var.load_distribution}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${element(azurerm_lb_probe.azlb.*.id,count.index)}"
  depends_on                     = ["azurerm_lb_probe.azlb"]
}

resource "azurerm_lb_rule" "trust_lb_rule" {
  count                          = "${length(var.lb_port)}"
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.azlb.id}"
  name                           = "${element(keys(var.lb_port), count.index)}-trust"
  protocol                       = "${element(var.lb_port["${element(keys(var.lb_port), count.index)}"], 1)}"
  frontend_port                  = "${element(var.lb_port["${element(keys(var.lb_port), count.index)}"], 0)}"
  backend_port                   = "${element(var.lb_port["${element(keys(var.lb_port), count.index)}"], 2)}"
  frontend_ip_configuration_name = "${var.frontend_name[1]}"
  enable_floating_ip             = true
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.trust_be.id}"
  load_distribution              = "${var.load_distribution}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${element(azurerm_lb_probe.azlb.*.id,count.index)}"
  depends_on                     = ["azurerm_lb_probe.azlb"]
}
