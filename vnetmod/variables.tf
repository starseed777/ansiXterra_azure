variable azure_rg {
    type = "string"
    default = "oraclerg"
}

variable azure_blob_rg {
    type = "string"
    default = "ansible"
}

variable azure_location {
    type = "string"
    default = "eastus"
}

variable vnet_cidr {
    type = "string"
    default = "10.0.0.0/16"
}

variable vnet_sub1 {
    type = "string"
    default = "10.0.1.0/24"
}

variable vnet_sub2 {
    type = "string"
    default = "10.0.2.0/24"
}

variable vm_size {
    type = "string"
    default = "Standard_DS2_v2"
}