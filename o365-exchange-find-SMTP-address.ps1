# Use this to quickly figure out who (or what) has a SMTP address.

# Connect to Exchange Online
Connect-ExchangeOnline -ShowProgress $true

# Search for the SMTP address
Get-Recipient -Filter "EmailAddresses -like 'smtp:hello@domain.com'"

# Or, print a list of everyone that has an emai laddres "like":
Get-Recipient -ResultSize Unlimited -Filter "EmailAddresses -like '*domain.com'" | Select-Object DisplayName, @{Name='AllSMTPAddresses';
                  Expression={($_.EmailAddresses |
                                Where-Object {$_ -match '^smtp:'} |
                                ForEach-Object {$_ -replace '^smtp:',''}) -join ', '}}
