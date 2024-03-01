#Connect to Exchange online
Connect-ExchangeOnline -ShowProgress $true

# Run 1-liner (results displayed in MB - change this if needed)
((get-exomailbox -ResultSize Unlimited | get-exomailboxstatistics).TotalItemSize.Value.ToMB() | measure-object -sum).sum

#Credit: https://sid-500.com/2020/05/27/exchange-online-get-total-size-of-all-mailboxes/
