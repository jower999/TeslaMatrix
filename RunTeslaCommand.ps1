#! /usr/local/bin/pwsh
param 
(
    $command,
    [pscredential]$cred=$(if (Test-Path variable:\teslacred){$teslacred}else{Get-Credential -Message "Enter your Tesla credentials"})
)
Import-Module TeslaMatrix -argumentlist @{Credential=$cred} -Force
& $command
