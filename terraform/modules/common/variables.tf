variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "edge_vm_user_name" {
  type = string
}
variable "resource_prefix" {
  type    = string
  default = "" # The default value is empty, but in the usages of this variable it will be overridden by a generated value if left empty.
}
