# #############################################################################
# Service Bus Namespace
# #############################################################################

module "servicebus_namespace" {
  source  = "TaleLearnCode/servicebus_namespace/azurerm"
  version = "0.0.1-pre"
  providers = {
    azurerm = azurerm
  }

  srv_comp_abbr       = var.srv_comp_abbr
  name_suffix         = var.name_suffix
  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.resource_name
}