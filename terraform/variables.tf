# User of the IoT Edge VM
variable "edge_vm_user_name" {
  type    = string
  default = "" # The default value is empty, but in the usages of this variable it will be overridden by a generated value if left empty.
}

variable "location" {
  type    = string
  default = "westeurope"
}
