# Connect to Exchange Online Powershell using
Connect-ExchangeOnline
# Connect to MS.Graph.
# -Scopes "User.ReadWrite.All" Should be sufficient for most operations below. 
# Some may require -Scopes "Directory.AccessAsUser.All"
Connect-MgGraph -Scopes "User.ReadWrite.All" 

### Add user ################################################################################################################################################################################

# First, use this to see total license count & types of licenses avaialable for assignment in next step
Get-MgSubscribedSku | Select-Object `
  @{Name="LicenseName";Expression={$_.SkuPartNumber}}, `
  @{Name="ConsumedUnits";Expression={$_.ConsumedUnits}}, `
  @{Name="PrepaidEnabled";Expression={$_.PrepaidUnits.Enabled}}, `
  @{Name="LicensesAvailable";Expression={($_.PrepaidUnits.Enabled) - ($_.ConsumedUnits)}} | Format-Table -AutoSize

# Get the SKU of the license you want to assign (replace "O365_BUSINESS_PREMIUM" with desired LicenseName
Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -eq "O365_BUSINESS_PREMIUM"}

# Assign the license
$sku = Get-MgSubscribedSku | Where-Object {$_.SkuPartNumber -eq "O365_BUSINESS_PREMIUM"} # store the SKU in $sku
$UserId = "<Account>" # change that
$addLicenses = @(@{ SkuId = $sku.SkuId})
RemoveLicenses = @()  # If you want to remove any licenses, specify here, else leave empty
New-MgUserLicenseUpdate -UserId $UserId -AddLicenses $addLicenses -RemoveLicenses $RemoveLicenses

### Reanimate old user user #################################################################################################################################################################

# Do steps above first to assign lic.
# Then, convert the mailbox from shared to regular
Set-Mailbox -Identity "<Account>" -type Regular

# If the old user's login name was changed and needs to be changed back:
Update-MgUser -UserId currentUserName@company.com -UserPrincipalName "newUsername@company.com"

### Remove User #############################################################################################################################################################################
# Convert Mailbox to Shared
Set-Mailbox "<Account>" -Type Shared

# Optional - Fwd User's e-mail to another person since the mailbox is being archived
Set-Mailbox -Identity "<Account>" -ForwardingAddress "<Forwarding Address Account>" # add "-DeliverToMailboxAndForward $true" if a copy must be retained in the mailbox after forwarding

# Optional - give another user acess to the mailbox
# Below cmd assigns Adam full access to Steve's mailbox
# re-run cmd "-AccessRights FullAccess" with "AccessRights SendAs" to allow send as (i.e. if assigning shared mailbox rights)
Add-MailboxPermission -Identity "Steve" -User "Adam" -AccessRights FullAccess -InheritanceType All

# Remove the license
# First, use this to see user's assigned licenses 
Get-MgUserLicenseDetail -UserId "<Account>" | Format-List SkuPartNumber

# Then remove license(s) as needed 
# See "# Assign the license" section above

### Shared Mailbox Management ###############################################################################################################################################################
# Create the shared mailbox
New-Mailbox -Shared -Name "CompanyName Human Resources" -DisplayName "CompanyName Human Resources" -alias "human.resources"
# Give a user access to this shared mailbox
Add-MailboxPermission -Identity "human.resources@companydomain.com" -User "john@companydomain.com" -AccessRights FullAccess -InheritanceType All
# And if the user needs to send as:
Add-RecipientPermission -Identity "human.resources@companydomain.com" -AccessRights SendAs -Trustee "john@companydomain.com"

### Setup OORL ##############################################################################################################################################################################
# Setup out of office reply for a user
Set-MailboxAutoReplyConfiguration -Identity "john.s@contoso.com" -AutoReplyState Enabled -ExternalMessage "I am no longer with Contoso" -InternalMessage "I am no longer with Contoso"

### Exit gracefully #########################################################################################################################################################################
# Disconnect from Exchange Online Powershell using
Disconnect-ExchangeOnline -Confirm:$false

# Disconnect graph session
Disconnect-MgGraph
