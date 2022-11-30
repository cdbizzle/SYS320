# Create commandline parameters to copt a file and place into an evidence directory
param(
[Parameter(Mandatory = $true)]
[int]$reportNo,

[Parameter(Mandatory = $true)]
[String]$filePath
)

# Create a directory with a report number
$reportDir = "rpt$reportNo"

# Create a new directory
mkdir $reportDir

# Copy the file into the new directory
Copy-Item $filePath $reportDir