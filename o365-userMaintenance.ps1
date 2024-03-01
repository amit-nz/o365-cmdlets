# Conenct to o365 AD first, using 
Connect-MsolService
# Connect to Exchange Online Powershell using
Connect-ExchangeOnline

### Add user ######################################################################################################################################################################################

# Check if user has synced from onsite AD
Get-MsolUser -All | findstr "<Name>"

# Assign the user's usage location
Set-MsolUser -UserPrincipalName "<Account>" -UsageLocation NZ

# First, use this to see total license count & types of licenses avaialable for assignment in next step
Get-MsolAccountSku

# Assign the license
Set-MsolUserLicense -UserPrincipalName "<Account>" -AddLicenses "<AccountSkuId>"

### Remove User ######################################################################################################################################################################################

# Convert Mailbox to Shared
Set-Mailbox "<Account>" -Type Shared

# Optional - Fwd User's e-mail to another person since the mailbox is being archived
Set-Mailbox -Identity "<Account>" -ForwardingAddress "<Forwarding Address Account>"

# Optional - give another user acess to the mailbox
# Below cmd assigns Adam full access to Steve's mailbox
# re-run cmd "-AccessRights FullAccess" with "AccessRights SendAs" to allow send as (i.e. if assigning shared mailbox rights)
Add-MailboxPermission -Identity "Steve" -User "Adam" -AccessRights FullAccess -InheritanceType All

# Remove the license
# First, use this to see user's assigned licenses 
Get-MsolUser -UserPrincipalName "<Account>" | Format-List DisplayName,Licenses

# Then remove license(s) as needed
Set-MsolUserLicense -UserPrincipalName "<Account>" -RemoveLicenses "<SKU>"

### Shared Mailbox Management ######################################################################################################################################################################################
# Create the shared mailbox
New-Mailbox -Shared -Name "CompanyName Human Resources" -DisplayName "CopmanyName Human Resources" -alias "human.resources"
# Give a user access to this shared mailbox
Add-MailboxPermission -Identity "human.resources@companydomain.com" -User "john@companydomain.com" -AccessRights FullAccess -InheritanceType All
# And if the user needs to send as:
Add-RecipientPermission -Identity "human.resources@companydomain.com" -AccessRights SendAs -Trustee "john@companydomain.com"

### Setup OORL #####################################################################################################################################################################################################
# Setup out of office reply for a user
Set-MailboxAutoReplyConfiguration -Identity "john.s@contoso.com" -AutoReplyState Enabled -ExternalMessage "I am no longer with Contoso" -InternalMessage "I am no longer with Contoso"

# Disconnect from Exchange Online Powershell using
Remove-PSSession $Session