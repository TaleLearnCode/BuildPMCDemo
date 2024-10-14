# #############################################################################
# Key Vault
# #############################################################################

module "key_vault" {
  source  = "TaleLearnCode/key_vault/azurerm"
  version = "0.0.2-pre"
  providers = {
    azurerm = azurerm
  }

  srv_comp_abbr       = var.srv_comp_abbr
  name_suffix         = var.name_suffix
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  all_access_users    = [ data.azurerm_client_config.current.object_id, data.azuread_service_principal.terraform.object_id ]
  depends_on = [
     module.resource_group
  ]
}