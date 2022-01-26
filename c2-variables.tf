variable "resource_group_name" {
  type = string
}
variable "resource_group_location" {
  type = string
}
variable "vnet_name" {
  type = string
}
variable "vnet_address_space" {
  type = list(string)
}
variable "snet_name" {
  type = string
}
variable "snet_address_space" {
  type = list(string)
}
variable "publicip_name" {
  type = string
}
variable "publicip_allocation" {
  type = string
}
variable "network_interface_name" {
  type = string
}
variable "vm_name" {
  type = string
}