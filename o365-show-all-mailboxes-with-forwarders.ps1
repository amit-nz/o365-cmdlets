# Connect to o365 Exch Online
Connect-ExchangeOnline

# List all mailboxes with active forwarders
# Note - this will not show outlook rules. Just transport level rules. See below
Get-Mailbox | select UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward

# The below shows outlook rules & what they do
# Todo: Loop through and print
Get-InboxRule -Mailbox user@domain.com | Select Name, Description | FL
