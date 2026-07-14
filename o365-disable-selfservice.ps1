# Install the module
Install-Module -Name MSCommerce -Scope CurrentUser

# Import the module
Import-Module MSCommerce

# Connect
Connect-MSCommerce

# Disable anything that is "allowed"
Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase |
    Where-Object { $_.PolicyValue -eq 'Enabled' -or $_.PolicyValue -eq 'OnlyTrialsWithoutPaymentMethod' } |
    ForEach-Object {
        Write-Host "Disabling: $($_.ProductName) ($($_.ProductId))"
        Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -ProductId $_.ProductId -Enabled $false
    }
