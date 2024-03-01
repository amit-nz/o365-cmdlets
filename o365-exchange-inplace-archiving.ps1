# Connect to o365 Exch Online
Connect-ExchangeOnline

# Check if retention hold is enabled - this will prevent archiving from runnning
Get-Mailbox -Identity user@domain.com | select RetentionHoldEnabled
# Expected result is "False"

# Enable the in place archive
Enable-Mailbox -Identity user@domain.com -archive

# Start the managed folder assistant to begin archiving process (can still take several hours after)
Start-ManagedFolderAssistant -Identity user@domain.com 

# Check message count in the archive mailbox
Get-MailboxStatistics -Identity user@domain.com  -archive | Select DisplayName, TotalItemSize, ItemCount