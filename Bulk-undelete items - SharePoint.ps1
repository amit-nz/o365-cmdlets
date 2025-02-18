# Requires PowerShell 7
# First, install PnP.Powershell as per https://pnp.github.io/powershell/articles/installation.html

# Register a new app because the previous method of simply authenticating the old fashonied way is too easy. Make a note of the AzureAppId/ClientId that the system spits out. 
# If you have done this in the past already, go to https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade/quickStartType~/null/sourceType/Microsoft_AAD_IAM
# and click "View all applications in directory", then find "PnP" or whatever you called it, look for Application (client) ID
Register-PnPEntraIDAppForInteractiveLogin -ApplicationName "PnP" -Tenant meridianconstructionltd.onmicrosoft.com -Interactive

# Connect to the sharepoint lib (replace URL + client ID)
Connect-PnPOnline -Url "https://focis-co-nz-my.sharepoint.com/personal/amit" -Interactive -ClientID "111111-111-111-1111-aaaaaaaa"
Connect-PnPOnline -Url "https://focis.sharepoint.com/sites/AwesomeSharedLocation" -Interactive -ClientID "111111-111-111-1111-aaaaaaaa"

# Example 1 - List items in recycle bin -- useful to verify if deleted items are there and to get the filter scoping right
Get-PnPRecycleBinItem -RowLimit 50 | Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Format-table -AutoSize
# Example 2 -  export to CSV - useful for confirming full dataset by viewing resulting csv in a text editor or similar
Get-PnPRecycleBinItem | Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Export-Csv -Path FileList.csv
# Example 3 - As above but only stuff that was deleted yesterday and onl a specific user. Note time zone in UTC here.
Get-PnPRecycleBinItem | Where-Object { ($_.DeletedDate).Date -eq (Get-Date).AddDays(-1).Date -and $_.DeletedByName -eq "Johnny Boy" } | Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Export-Csv -Path FileList-Yesterday-deletedby-Johnny.csv

# To bulk restore all items in there now (careful!)
Get-PnPRecycleBinItem | Restore-PnpRecycleBinItem -Force

# Example 2 (only restore items deleted by Johnny, yesterday.
Get-PnPRecycleBinItem | Where-Object { ($_.DeletedDate).Date -eq (Get-Date).AddDays(-1).Date -and $_.DeletedByName -eq "Johnny Boy" } | Restore-PnpRecycleBinItem -Force
