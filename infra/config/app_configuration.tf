# #############################################################################
# App Configuration
# #############################################################################

module "app_configuration" {
  source  = "TaleLearnCode/app_configuration/azurerm"
  version = "0.0.3-pre"
  providers = {
    azurerm = azurerm
  }
  
  location                      = var.location
  environment                   = var.environment
  resource_group_name           = module.resource_group.resource_group.name
  srv_comp_abbr                 = var.srv_comp_abbr
  name_suffix                   = var.name_suffix
  app_configuration_data_owners = [ data.azurerm_client_config.current.object_id, data.azuread_service_principal.terraform.object_id ]
  depends_on = [
     module.resource_group
  ]
}