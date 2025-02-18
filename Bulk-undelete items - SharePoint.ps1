# Requires PowerShell 7
# First, install PnP.Powershell as per https://pnp.github.io/powershell/articles/installation.html

# Register a new app because the previous method of simply authenticating the old fashonied way is too easy. Make a note of the AzureAppId/ClientId that the system spits out. 
Register-PnPEntraIDAppForInteractiveLogin -ApplicationName "PnP" -Tenant meridianconstructionltd.onmicrosoft.com -Interactive
# If you have done this in the past already, go to https://entra.microsoft.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade/quickStartType~/null/sourceType/Microsoft_AAD_IAM
# and click "View all applications in directory", then find "PnP" or whatever you called it, look for Application (client) ID

# Once you have the client ID, connect to the sharepoint lib (replace URL + client ID):
Connect-PnPOnline -Url "https://myorg-com-my.sharepoint.com/personal/amit" -Interactive -ClientID "111111-111-111-1111-aaaaaaaa"
Connect-PnPOnline -Url "https://myorg.sharepoint.com/sites/AwesomeSharedLocation" -Interactive -ClientID "111111-111-111-1111-aaaaaaaa"

# Example 1 - List items in recycle bin -- useful to verify if deleted items are there and to get the filter scoping right
Get-PnPRecycleBinItem -RowLimit 50 | Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Format-table -AutoSize
# Example 2 -  export to CSV - useful for confirming full dataset by viewing resulting csv in a text editor or similar
Get-PnPRecycleBinItem | Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Export-Csv -Path FileList.csv
# Example 3 - As above but only stuff that was deleted yesterday and onl a specific user. Note time zone in UTC here.
Get-PnPRecycleBinItem | Where-Object { ($_.DeletedDate).Date -eq (Get-Date).AddDays(-1).Date -and $_.DeletedByName -eq "Johnny Boy" } | Select Title, ItemType, Size, ItemState, DirName, DeletedByName, DeletedDate | Export-Csv -Path FileList-Yesterday-deletedby-Johnny.csv

# To bulk restore all items in there now (careful!), no confirmation due to -Force
Get-PnPRecycleBinItem | ForEach-Object { Restore-PnPRecycleBinItem  -Force }

# Example 2 (only restore items deleted by Johnny, yesterday.
Get-PnPRecycleBinItem | Where-Object { ($_.DeletedDate).Date -eq (Get-Date).AddDays(-1).Date -and $_.DeletedByName -eq "Johnny Boy" } | ForEach-Object { Restore-PnPRecycleBinItem  -Force }

# Example 3 - slightly more complicated. Yesterday, Johnny accidentally moved a folder (dragged and dropped a pinned item in explorer to another folder)
# The move operation was interrupted however some files had been deleted at the source; yet they are reported by Get-PnPRecycleBinItem
# The loop checks if the item exists at the destination; if it does, it will not restore. If it does not, it will restore the file.
Get-PnPRecycleBinItem | Where-Object { ($_.DeletedDate).Date -eq (Get-Date).AddDays(-1).Date -and $_.DeletedByName -eq "Johnny Boy" } | ForEach-Object {
        $path = "/$($_.DirName)/$($_.LeafName)"
    Get-PnPFile -Url $path
    $fileExists = Get-PnPFile -url $path -ErrorAction SilentlyContinue
    if (!$fileExists) {
        $_ | Restore-PnpRecycleBinItem -Force -ErrorAction SilentlyContinue
    }
}
