# #############################################################################
# Application Insights
# #############################################################################

module "application_insights" {
  source  = "TaleLearnCode/application_insights/azurerm"
  version = "0.0.6-pre"
  providers = {
    azurerm = azurerm
  }

  srv_comp_abbr       = var.srv_comp_abbr
  name_suffix         = var.name_suffix
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.resource_name
  application_type    = "web"
  workspace_id        = module.log_analytics_workspace.workspace.id
  depends_on = [ module.log_analytics_workspace ]
}