# #############################################################################
# Resource Group
# #############################################################################

module "resource_group" {
  source  = "TaleLearnCode/resource_group/azurerm"
  version = "0.0.1-pre"
  providers = {
    azurerm = azurerm
  }

  location      = var.location
  environment   = var.environment
  srv_comp_abbr = var.srv_comp_abbr
  name_suffix   = var.name_suffix
}