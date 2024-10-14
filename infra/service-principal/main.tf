# #############################################################################
# Provider configuration
# #############################################################################

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }
}

# #############################################################################
# Variables
# #############################################################################

variable "subscription_id" {
  type        = string
  description = "The Azure subscription identifier."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be deployed."
}

variable "environment" {
  type        = string
  description = "The environment where the resources will be deployed."
}

variable "name_suffix" {
  type        = string
  description = "The suffix to append to the names of the resources."
}

variable "service_principal_name" {
  type        = string
  description = "The name of the service principal"
}

# #############################################################################
# Data sources
# #############################################################################

data "azuread_client_config" "current" {}

# #############################################################################
# Resources
# #############################################################################

resource "azuread_application" "catalog_developer" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "catalog_developer" {
  client_id                    = azuread_application.catalog_developer.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "catalog_developer" {
  service_principal_id = azuread_service_principal.catalog_developer.object_id
}

# #############################################################################
# Output Files
# #############################################################################

resource "local_file" "service_principal_credentials" {
  content  = <<EOF
Service Principal Name: ${var.service_principal_name}
Client ID: ${azuread_service_principal.catalog_developer.client_id}
Client Secret: ${azuread_service_principal_password.catalog_developer.value}
Tenant ID: ${data.azuread_client_config.current.tenant_id}
EOF
  filename = "${path.module}/service_principal_credentials.txt"
}

resource "local_file" "config_tfvars" {
  content  = <<EOF
subscription_id        = "${var.subscription_id}"
location               = "${var.location}"
environment            = "${var.environment}"
name_suffix            = "${var.name_suffix}"
service_principal_name = "${var.service_principal_name}"
EOF
  filename = "${path.module}/config.tfvars"
}

resource "local_file" "app_tfvars" {
  content  = <<EOF
subscription_id        = "${var.subscription_id}"
location               = "${var.location}"
environment            = "${var.environment}"
name_suffix            = "${var.name_suffix}"
service_principal_name = "${var.service_principal_name}"
EOF
  filename = "${path.module}/app.tfvars"
}