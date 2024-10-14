# #############################################################################
# Storage Account
# #############################################################################


module "storage_account" {
  source  = "TaleLearnCode/storage_account/azurerm"
  version = "0.0.6-pre"
  providers = {
    azurerm = azurerm
  }

  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.resource_name
  srv_comp_abbr       = var.srv_comp_abbr
  name_suffix         = var.name_suffix

  containers = {
    "chatlogarchive" = {
      container_access_type = "private"
    }
    "projectdetaillocalstorage" = {
      container_access_type = "private"
    }
  }
  tables = [ "userprofiles" ]
}