# Packer "{{ env `newAdminPassword` }}
# $Env:adminPassword
# 
Write-Output \"/The password is $Env:newAdminPassword\"
$UserAccount = Get-LocalUser -Name "Administrator"
$UserAccount | Set-LocalUser -Password (ConvertTo-SecureString -AsPlainText $Env:NewAdminPassword -Force)