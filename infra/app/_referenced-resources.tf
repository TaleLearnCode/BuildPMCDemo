# #############################################################################
# Referenced Resources
# #############################################################################

# -----------------------------------------------------------------------------
# Resource Group
# -----------------------------------------------------------------------------

module "resource_group" {
  source  = "TaleLearnCode/naming/azurerm"
  version = "0.0.2-pre"

  resource_type  = "resource_group"
  srv_comp_abbr  = var.srv_comp_abbr
  name_suffix    = var.name_suffix
  location       = var.location
  environment    = var.environment
}

# -----------------------------------------------------------------------------
# Key Vault
# -----------------------------------------------------------------------------

module "key_vault" {
  source  = "TaleLearnCode/naming/azurerm"
  version = "0.0.2-pre"

  resource_type  = "key_vault"
  srv_comp_abbr  = var.srv_comp_abbr
  name_suffix    = var.name_suffix
  location       = var.location
  environment    = var.environment
}

data "azurerm_key_vault" "kv" {
  name                = module.key_vault.resource_name
  resource_group_name = module.resource_group.resource_name
}

# -----------------------------------------------------------------------------
# App Configuration
# -----------------------------------------------------------------------------

module "app_configuration" {
  source  = "TaleLearnCode/naming/azurerm"
  version = "0.0.2-pre"

  resource_type  = "app_configuration"
  srv_comp_abbr  = var.srv_comp_abbr
  name_suffix    = var.name_suffix
  location       = var.location
  environment    = var.environment
}

data "azurerm_app_configuration" "appcs" {
  name                = module.app_configuration.resource_name
  resource_group_name = module.resource_group.resource_name
}