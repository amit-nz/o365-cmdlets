# Requires PowerShell 7
# First, install PnP.Powershell as per https://pnp.github.io/powershell/articles/installation.html

# Connect to users' sharepoint lib (replace URL as needed)
Connect-PnPOnline -Url "https://focis-co-nz-my.sharepoint.com/personal/amit" -Interactive

# List items in user's recycle bin -- verify deleted items are there
Get-PnPRecycleBinItem -RowLimit 500000 | Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Format-table -AutoSize
# Note - to export to CSV, add suffix the cmdlet with "Export-Csv -Path FileList.csv"

# To bulk restore items: 
$DeletedItems = Get-PnPRecycleBinItem -RowLimit 500000
$DeletedItems | Restore-PnpRecycleBinItem -Force