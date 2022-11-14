# Week 11 Powershell Threat Emulation
# Create the file using info from the threat report
$num = Get-Random -Minimum 1000 -Maximum 9876
$fileName = "\EnNoB-$num.exe"
$dir = "$env:USERPROFILE"
$fullPath = $dir+$fileName
Copy-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" -Destination $fullPath

# Check if the file already exists
if ( Test-Path $fullPath ) {
    Write-Host -BackgroundColor "Green" -ForegroundColor "White" "File '$fullPath' was found"
} else {
    Write-Host -BackgroundColor "Red" -ForegroundColor "White" "File '$fullPath' was NOT found"
}

# Add README file to Desktop
$readLocation = $dir + "\Desktop\README.READ"
$msg = "If you want your files restored, please contact me at test@email.com. I look forward to doing business with you."
$msg | Out-File -FilePath $readLocation 

# Check if README file exists
if ( Test-Path $readLocation ) {
    Write-Host -BackgroundColor "Green" -ForegroundColor "White" "File '$readLocation' was found"
} else {
    Write-Host -BackgroundColor "Red" -ForegroundColor "White" "File '$readLocation' was NOT found"
}