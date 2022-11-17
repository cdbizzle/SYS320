Clear-Host
# Login to a remote SSH server
New-SSHSession -ComputerName '192.168.0.134' -Credential (Get-Credential user)

while ($True) {
    # Add a prompt to run commands
    $theCMD = Read-Host -Prompt "Please enter a command"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 $theCMD).Output
}

#Set-SCPItem -ComputerName '192.168.0.134' -Credential (Get-Credential user) -Destination '/home/user' -Path '.\Week12\class\testSCP.txt'
