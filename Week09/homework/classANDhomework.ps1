$servicesOutputName = "C:\Users\colec\Desktop\SYS320\Week09\homework\Services.csv"
$runningOutputName = "C:\Users\colec\Desktop\SYS320\Week09\homework\runningServices.csv"

# Get a list of running processes

# Get list of members
#Get-Process | Get-Member

# Get a list of processes: name, id, path
#Get-Process | Select-Object ProcessName, Path, Id

# Save the output to a CSV file
#Get-Process | Select-Object ProcessName, Path, Id | Export-Csv -Path C:\Users\colec\Desktop\SYS320\Week09\class\processes.csv

# System services and properties
#Get-Service | Get-Member
#Get-Service | Select-Object Status, Name, DisplayName, BinaryPathName | Export-Csv -Path $outputName

# Get a list of running services
Get-Service | Where-Object { $_.Status -eq "Running" } | Export-Csv -Path $runningOutputName
if ( Test-Path $runningOutputName ) {
    Write-Host -BackgroundColor "Green" -ForegroundColor "White" "Running services file was created!"
} else {
    Write-Host -BackgroundColor "Red" -ForegroundColor "White" "Running services file was not created"
}


# Check to see if the file exists
if ( Test-Path $servicesOutputName ) {
    Write-Host -BackgroundColor "Green" -ForegroundColor "White" "Services file was created!"
} else {
    Write-Host -BackgroundColor "Red" -ForegroundColor "White" "Services file was not created"
}
