# #############################################################################
# App Settings
# #############################################################################

resource "local_file" "app_settings" {
  content  = <<EOF
App Configuration Endpoint: ${module.app_configuration.app_configuration.endpoint}
EOF
  filename = "${path.module}/config.appsettings"
}