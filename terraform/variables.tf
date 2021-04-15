variable "resource_group_location" {
  type    = string
  default = "West Europe"
}

# User of the IoT Edge VM
variable "edge_vm_user_name" {
  type    = string
  default = "" # The default value is empty, but in the usages of this variable it will be overridden by a generated value if left empty.
}

# Password of the IoT Edge VM
variable "edge_vm_password" {
  type      = string
  sensitive = true
  default   = "" # The default value is empty, but in the usages of this variable it will be overridden by a generated value if left empty.
}
