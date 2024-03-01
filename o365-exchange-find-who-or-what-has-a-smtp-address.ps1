# Connect to Exchange Online
Connect-ExchangeOnline -ShowProgress $true

# Search for the SMTP address
Get-Recipient -Filter "EmailAddresses -like 'smtp:hello@domain.com'"
