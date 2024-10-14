# Display header message
$headerColor = "Cyan"
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host "    Executing Config Terraform Project   " -ForegroundColor $headerColor
Write-Host "=========================================" -ForegroundColor $headerColor
Write-Host

# Prompt for the necessary information
$environment = (Read-Host -Prompt 'Environment')

# Save the current location
$originalLocation = Get-Location

# Set the location to where the script is located
$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location -Path $scriptDir

# Change to the directory containing the Terraform configuration
Set-Location -Path '..\infra\config'

# Initialize Terraform
terraform init
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Validate the configuration
terraform validate
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Apply the configuration with the service principal name
terraform apply -var-file "$environment.tfvars"
if ($LASTEXITCODE -ne 0) { Set-Location -Path $originalLocation; exit $LASTEXITCODE }

# Return to the original location
Set-Location -Path $originalLocation

# Display completion message
Write-Host "========================================="
Write-Host "       Terraform Script Completed        "
Write-Host "========================================="