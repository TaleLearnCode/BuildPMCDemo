# #############################################################################
# Variables
# #############################################################################

variable "subscription_id" {
  type        = string
  description = "Identifier of the Azure subscription."
}

variable "location" {
  type        = string
  default     = "northcentralus"
  description = "Location of the Azure resources."
}

variable "environment" {
  type        = string
  description = "Environment of the Azure resources."
}

variable "service_principal_name" {
  type        = string
  description = "Display name of the Terraform service principal."
}

variable "srv_comp_abbr" {
  type        = string
  default     = "PMC"
  description = "Abbreviation of the service component."
}

variable "name_suffix" {
  type        = string
  description = "Suffix to append to the name of the resource."
}