# List all files and print the full path
Get-ChildItem -Recurse -Include *.docx,*.pdf,*.txt .\Documents | Select FullName

# Export files to a CSV
Get-ChildItem -Recurse -Include *.docx,*.pdf,*.txt .\Documents | Export-Csv -Path files.csv

# Import CSV file
$fileList = Import-Csv -Path .\files.csv -Header FullName

# Loop through the results
foreach ($f in $fileList) {
    Get-ChildItem -Path $f.FullName
}