data "amazon-ami" "Aws-Win2k19" {
  filters = {
    name                = "Windows_Server-2019-English-Full-Base-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["801119661308"]
}


source "amazon-ebs" "Aws-Win2k19" {
  access_key                  = "${var.aws_access_key_id}"
  ami_name                    = "${var.aws_w2k19_vm_name_prefix}-${var.BUILDTIME}"
  associate_public_ip_address = "${var.aws_public_ip_address}" # Bool
  communicator                = "winrm"
  encrypt_boot                = true
  instance_type               = "t2.large"
  region                      = "${var.aws_region}"
  secret_key                  = "${var.aws_secret_key}"
  security_group_id           = "${var.aws_security_group_id}"
  source_ami                  =  data.amazon-ami.Aws-Win2k19.id
  subnet_id                   = "${var.aws_subnet_id}"
  user_data_file              = "../scripts/awsUserDataOrg.ps1"
  vpc_id                      = "${var.aws_vpc_id}"
  winrm_insecure              = true
  winrm_username              = "${var.new_ansible_user}"
  winrm_password              = "${var.new_ansible_password}"
  winrm_port                  = 5986
  winrm_timeout               = "30m"
  winrm_use_ssl               = true
}

source "vsphere-iso" "vSphere-CentOS8" {
  CPUs                 = "2"
  RAM                  = "2048"
  RAM_reserve_all      = false
  # http_directory       = "../centos_http"
  boot_command         = [
                          "<up><wait><tab><wait>",
                          " inst.ks=${var.http_server}/centos8.cfg<enter>",
                          "<wait>"]
  boot_order           = "disk,cdrom"
  cluster              = "${var.vc_cluster}"
  convert_to_template  = "true"
  create_snapshot      = "false"
  datastore            = "${var.vc_datastore}"
  disk_controller_type = ["pvscsi"]
  firmware             = "bios"
  # floppy_files         = ["../config/centos8.cfg"]
  folder               = "${var.vc_folder}"
  guest_os_type        = "centos8_64Guest"
  # host                 = "${var.vcenter_host}"
  insecure_connection  = "true"
  iso_checksum         = "${var.vsphere_centos8_checksum}"
  iso_paths            = ["${var.vsphere_centos8_iso}"]
  network_adapters {
    network      = "${var.vc_network}"
    network_card = "vmxnet3"
  }
  # notes            = "Default SSH User: ${var.ssh_username}\nDefault SSH Pass: ${var.ssh_password}\nBuilt by Packer @ ${legacy_isotime("2006-01-02 03:04")}."

  remove_cdrom     = "true"
  # need to change username and password in config/centos8.cfg
  shutdown_command = "echo '${var.new_ansible_password}' | sudo -S -E shutdown -P now"
  ssh_password     = "${var.ssh_password}"
  ssh_username     = "root"
  storage {
    disk_size             = "20480"
    disk_thin_provisioned = true
  }
  username       = "${var.vc_username}"
  password         = "${var.vc_password}"
  vcenter_server = "${var.vc_server}"
  vm_name        = "${var.vsphere_centos8_vm_name_prefix}-${var.BUILDTIME}"
}

source "vsphere-iso" "vSphere-Win2k19" {
  CPUs                 = "${var.vsphere_win2k19_vm_cpu_num}"
  RAM                  = "${var.vsphere_win2k19_vm_mem_size}"
  RAM_reserve_all      = false
  cluster              = "${var.vc_cluster}"
  communicator         = "winrm"
  convert_to_template  = "true"
  datacenter           = "${var.vc_datacenter}"
  datastore            = "${var.vc_datastore}"
  disk_controller_type = ["pvscsi"]
  firmware             = "bios"
  floppy_files         = ["../config/autounattend.xml","../scripts/addNewWindowsUser.ps1", "../scripts/disable-network-discovery.cmd", "../scripts/enable-rdp.cmd", "../scripts/enable-winrm.ps1", "../scripts/install-vm-tools.cmd", "../scripts/disable-all-fw.ps1","../drivers/pvscsi.cat", "../drivers/pvscsi.inf", "../drivers/pvscsi.sys", "../drivers/pvscsiver.dll"]
  folder               = "${var.vc_folder}"
  guest_os_type        = "windows9Server64Guest"
  insecure_connection  = "true"
  iso_paths            = ["${var.vsphere_win2k19_os_iso_path}", "[] /vmimages/tools-isoimages/windows.iso"]
  network_adapters {
    network      = "${var.vc_network}"
    network_card = "vmxnet3"
  }
  password     = "${var.vc_password}"
  remove_cdrom = true
  storage {
    disk_size             = "${var.vsphere_win2k19_vm_disk_size}"
    disk_thin_provisioned = true
  }
  username       = "${var.vc_username}"
  vcenter_server = "${var.vc_server}"
  vm_name        = "${var.vsphere_win2k19_vm_name_prefix}-${var.BUILDTIME}"
  winrm_password = "${var.new_ansible_password}"
  winrm_username = "${var.new_ansible_user}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {

sources = ["source.vsphere-iso.vSphere-Win2k19","source.vsphere-iso.vSphere-CentOS8","source.amazon-ebs.Aws-Win2k19"]

  provisioner "shell" {
    # execute_command = "echo '${var.new_ansible_password}' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["vsphere-iso.vSphere-CentOS8"]
    scripts         = ["../scripts/ssh_config.sh", "../scripts/centos_update.sh"]
  }

  provisioner "shell" {
    # execute_command = "echo '${new_ansible_password}' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["vsphere-iso.vSphere-CentOS8-CentOS8"]
    scripts         = ["../scripts/centos_8.sh"]
  }
 
    provisioner "windows-update" { 
    pause_before = "5m" 
    only            = ["vsphere-iso.vSphere-Win2k19","amazon-ebs.Aws-Win2k19"]
  }

      provisioner "windows-update" { 
      pause_before = "5m" 
      only            = ["vsphere-iso.vSphere-Win2k199","amazon-ebs.Aws-Win2k19"]
  }

}


