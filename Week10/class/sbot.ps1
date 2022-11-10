# Send an email using Powershell
$toSend = @('cole.davisbrand@mymail.champlain.edu', 'coleTest1@mymail.champlain.edu','coleTest2@mymail.champlain.edu')

# Message body
$msg = "Hello"

while ($true) {
    foreach ($email in $toSend) {
    # Send the email
        Write-Host "Send-MailMessage -From 'cole.davisbrand@mymail.champlain.edu' -To $email -Subject 'Enjoy!'' -Body $msg `
        -SmtpServer X.X.X.X"
        # Pause for one second
        Start-Sleep 1
    }
}