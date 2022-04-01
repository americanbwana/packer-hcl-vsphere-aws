Write-Host "Adding new WinRM user"
$password = ConvertTo-SecureString "newAnsiblePassword" -AsPlainText -Force
$newUser = New-LocalUser -Name "newAnsibleUser" -Password $password -FullName "Ansible Remote User" -Description "Ansible remote user" 
Add-LocalGroupMember -Group "Administrators" -Member $newUser
Start-Sleep -Seconds 30