# Array of websites containing threat intel
$dropURLs = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rules list
foreach ($u in $dropURLs) {
    # Extract the filename
    $temp = $u.split("/")
    $fileName = $temp[-1]
    # The last element in the array plucked off is the filename

    if (Test-Path $fileName) {
        continue
    } else {
        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile "./Week12/class/$fileName"
    }
}

# Array containing the filename
$inputPaths = @('.\Week12\class\compromised-ips.txt','.\Week12\class\emerging-botcc.rules')

# Extract the IP addresses
$regexDrop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list
Select-String -Path $inputPaths -Pattern $regexDrop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath ".\Week12\class\ips-bad.tmp"

# Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
# after the IP address, and the remaining IPTables syntax and save the results to a file.
# iptables -A INPUT -s IP -j DROP
<#
(Get-Content -Path ".\Week12\class\ips-bad.tmp") | % `
{ $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} | `
Out-File -FilePath ".\Week12\class\iptables.bash"
#>

# Create variable for the prompt
$userCreds = Get-Credential user
$var = Read-host -Prompt "Please enter 'Windows' or 'IPTables'"

switch ( $var ) {
    'IPTables' {
        (Get-Content -Path ".\Week12\class\ips-bad.tmp") | % `
        { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} | `
        Out-File -FilePath ".\Week12\class\iptables.bash"
        Set-SCPItem -ComputerName '10.0.0.252' -Credential ($userCreds) `
        -Destination '/home/user' -Path '.\Week12\class\iptables.bash'
        # Create new SSH session and check for the file existing or not
        New-SSHSession -ComputerName '10.0.0.252' -Credential ($userCreds)
        (Invoke-SSHCommand -index 0 "ls").Output
    }
    'Windows' {
    # Create executable list of firewall rules to run against the list of bad IPs
    (Get-Content -Path ".\Week12\class\ips-bad.tmp") | % `
    { $_ -replace "^", "New-NetFirewallRule -DisplayName 'Block IPs' -Direction Outbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress " -replace "$"} | `
    Out-File -FilePath ".\Week12\homework\FirewallRules.ps1"
    }
}
