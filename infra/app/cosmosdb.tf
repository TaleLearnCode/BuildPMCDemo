# #############################################################################
# Cosmos DB
# #############################################################################

# -----------------------------------------------------------------------------
# Cosmos DB Account
# -----------------------------------------------------------------------------

module "cosmosdb" {
  source    = "TaleLearnCode/cosmosdb_account/azurerm"
  version   = "0.0.2-pre"
  providers = {
    azurerm = azurerm
  }

  srv_comp_abbr       = var.srv_comp_abbr
  name_suffix         = var.name_suffix
  location            = var.location
  environment         = var.environment
  resource_group_name = module.resource_group.resource_name

  capabilities = [ "EnableServerless" ]

  create_connection_string_secret = true
  key_vault_id                    = data.azurerm_key_vault.kv.id
  connection_string_secret_name   = "CosmosDBConnectionString"
}

data "azurerm_key_vault_secret" "cosmosdb_connection_string" {
  name         = module.cosmosdb.connection_string_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
  depends_on = [ module.cosmosdb ]
}

module "cosmosdb_connection_string" {
  source  = "TaleLearnCode/app_configuration_key/azurerm"
  version = "0.0.1-pre"
  providers = {
    azurerm = azurerm
  }

  configuration_store_id = data.azurerm_app_configuration.appcs.id
  type                   = "vault"
  key                    = "CosmosDBConnectionString"
  vault_key_reference    = data.azurerm_key_vault_secret.cosmosdb_connection_string.versionless_id
  label                  = var.environment

  depends_on = [ 
    module.cosmosdb
  ]
}

# -----------------------------------------------------------------------------
# Cosmos DB Database
# -----------------------------------------------------------------------------

module "cosmosdb_database" {
  source  = "TaleLearnCode/cosmosdb_sql_database/azurerm"
  version = "0.0.2-pre"
  providers = {
    azurerm = azurerm
  }

  name                = "ChatLogs"
  resource_group_name = module.resource_group.resource_name
  account_name        = module.cosmosdb.cosmosdb_account.name
  
  record_database_name_in_app_configuration = true
  configuration_store_id                    = data.azurerm_app_configuration.appcs.id
  app_configuration_key                     = "databaseName"
  app_configuration_label                   = [ var.environment ]

  depends_on = [
    module.cosmosdb
  ]
}

# -----------------------------------------------------------------------------
# Cosmos DB Container
# -----------------------------------------------------------------------------

module "cosmosdb_container" {
  source  = "TaleLearnCode/cosmosdb_sql_container/azurerm"
  version = "0.0.2-pre"
  providers = {
    azurerm = azurerm
  }

  name                = "ChatLogs"
  resource_group_name = module.resource_group.resource_name
  account_name        = module.cosmosdb.cosmosdb_account.name
  database_name       = module.cosmosdb_database.database.name
  partition_key_paths = ["/projectId"]
  
  record_container_name_in_app_configuration = true
  configuration_store_id                     = data.azurerm_app_configuration.appcs.id
  app_configuration_key                      = "containerName"
  app_configuration_label                    = [ var.environment ]

  depends_on = [
    module.cosmosdb_database
  ]
}