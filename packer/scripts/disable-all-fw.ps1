Write-Host "Disabling all FW profiles"
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False