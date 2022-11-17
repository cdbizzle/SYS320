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
(Get-Content -Path ".\Week12\class\ips-bad.tmp") | % `
{ $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} | `
Out-File -FilePath ".\Week12\class\iptables.bash"
