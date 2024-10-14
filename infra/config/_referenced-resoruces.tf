# #############################################################################
# Referenced resources
# #############################################################################

data "azurerm_client_config" "current" {}

data "azuread_service_principal" "terraform" {
  display_name = var.service_principal_name
}