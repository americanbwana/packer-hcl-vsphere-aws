# General variables 
variable "BUILDTIME" {}
# AWS section
variable "aws_access_key_id" {
    sensitive = true
}
variable "aws_secret_key" {
    sensitive = true
}
variable "aws_w2k19_vm_name_prefix" {
    default = "Aws-W2k19"
}
variable "aws_region" {
    default="us-east-2"
}
variable "aws_vpc_id" {
    default = "vpc-1234"
}
variable "aws_subnet_id" {
    default = "subnet-1234"
}
variable "aws_security_group_id" {
    default = "sg-1234"
}
variable "aws_public_ip_address" {
    type = bool
    default = true
}
# Winrm and ansible
variable "new_ansible_user" {
    default = "ansibleuser"
}
variable "new_ansible_password" {
    sensitive = true
}
variable "new_win_admin_password" {
    sensitive = true
}
variable "ssh_user" {
    default = "ansibleuser"
}
variable "ssh_password" {
    sensitive = true
}
variable "linux_root_password" {
    sensitive = true
}
# vSphere variables
variable "vsphere_centos8_iso" {
    default = "[datastore1] ISOs/CentOS-8.2.2004-x86_64-minimal.iso"
}
variable "vsphere_centos8_checksum" {
    default = "47ab14778c823acae2ee6d365d76a9aed3f95bb8d0add23a06536b58bb5293c0"
}

variable "vc_username" {
    default = "administrator@vsphere.local"
}
variable "vc_password" {
    sensitive = true
}
variable "vc_server" {
    default = "vc.corp.local"
}
variable "vc_datacenter" {
    default = "DC"
}
variable "vc_datastore" {
    default = "datastore1"
}
variable "vc_folder" {
    default = "Packer Templates"
}
variable "vc_cluster" {
    default = "CL1"
}
variable "vc_network" {
    default = "VM Network"
}
variable "vsphere_win2k19_vm_cpu_num" {
    default = 2
}
variable "vsphere_win2k19_vm_mem_size" {
    default = 8192
}
variable "vsphere_win2k19_os_iso_path" {
    default = "[datastore1] ISO/W2k19.iso "
}
variable "vsphere_win2k19_vm_disk_size" {
    default = 100
}
variable "vsphere_centos8_vm_name_prefix" {
    default = "vSphere-CentOS8"
}
variable "vsphere_win2k19_vm_name_prefix" {
    default = "vSphere-W2k19"
}
variable "http_server" {}
