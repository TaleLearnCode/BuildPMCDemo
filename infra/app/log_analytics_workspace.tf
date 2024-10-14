# #############################################################################
# Create a Log Analytics Workspace
# #############################################################################

module "log_analytics_workspace" {
  source  = "TaleLearnCode/log_analytics_workspace/azurerm"
  version = "0.0.3-pre"
  providers = {
    azurerm = azurerm
  }

  srv_comp_abbr       = var.srv_comp_abbr
  name_suffix         = var.name_suffix
  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.resource_name
  identity_type       = "SystemAssigned"
}