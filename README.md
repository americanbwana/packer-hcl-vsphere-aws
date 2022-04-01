# packer-hcl-vsphere-aws
Packer HCL to build Aws and vSphere Windows machines.  Also uses packer-windows-update-plugin

Update and source environment.env before running.

You may need to change the passwords in awsUserDataOrg.ps1, and addNewWindowsUser.ps1.

Tested against Packer 1.8.0

The Windows build will add a new Administrator user, which allows you to access it using WinRM.  Our use case is to run 
Ansible playbooks against a new deployed vRealize Automation machine.