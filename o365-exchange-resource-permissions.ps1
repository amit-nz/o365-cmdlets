# Cmdlets to allow all users in the org to view the details of an event in a shared calendar 

# Connect to Exchange Online
Connect-ExchangeOnline -ShowProgress $true

# Verify the permissions of the object you're operating on: 
Get-MailboxFolderPermission -Identity "user@domain.com:\Calendar"

# Give everyone the correct permisisons - in this case Read-Only to view the calendar
Set-MailboxFolderPermission -Identity "user@domain.com:\Calendar" -User Default -AccessRights Reviewer

# Prevent the resource from removing useful details from the calendar (adjust as needed) 
Set-CalendarProcessing -Identity  "user@domain.com:\Calendar" -AddOrganizerToSubject $false -DeleteSubject $false -DeleteComments $false

# Optional
# Verify the permissions of the object you've been operating on: 
Get-MailboxFolderPermission -Identity "user@domain.com:\Calendar"
