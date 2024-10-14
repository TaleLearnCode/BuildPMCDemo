# Display header message
$headerColor = "Cyan"
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host "         Starting Terraform Script       " -ForegroundColor $headerColor
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host

# Create a variable that stores the execution date and time in the format yyyymmddhhmmss
$executionDateTime = (Get-Date).ToString('yyyyMMddHHmmss')

# Generate a random value between 0 and 999, padded to three characters
$nameSuffix = '{0:D3}' -f (Get-Random -Minimum 0 -Maximum 1000)

# Prompt for the necessary information
$eventName = (Read-Host -Prompt 'Event Identifier').Trim() -replace '\s', ''
$location = (Read-Host -Prompt 'Azure Region')
$environment = (Read-Host -Prompt 'Environment')

# Prompt to sign into Azure using the Azure CLI
az login
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Get the subscription id
$subscription_id = az account show --query id -o tsv

# Save the current location
$originalLocation = Get-Location

# Set the location to where the script is located
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $scriptDir

# Change to the directory containing the Terraform configuration
Set-Location -Path '..\infra\service-principal'

# Initialize Terraform
terraform init
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Validate the configuration
terraform validate
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Create the TFVars file
$output = @"
subscription_id        = "$subscription_id"
location               = "$location"
environment            = "$environment"
name_suffix            = "$nameSuffix"
service_principal_name = "PMC-$eventName"
"@
$output | Out-File -FilePath "$executionDateTime.tfvars"

# Apply the configuration with the service principal name
terraform apply -var-file "$executionDateTime.tfvars" -auto-approve
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Copy the generated files to their appropriate locations
Copy-Item -Path ".\config.tfvars" -Destination "..\config\$environment.tfvars"
Copy-Item -Path ".\app.tfvars" -Destination "..\app\$environment.tfvars"

# Return to the original location
Set-Location -Path $originalLocation

# Display completion message
Write-Host "========================================="
Write-Host "       Terraform Script Completed        "
Write-Host "========================================="