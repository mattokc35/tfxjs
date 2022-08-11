atracker                       = {
  collector_bucket_name = "atracker-bucket"
  receive_global_events = true
  resource_group        = "slz-service-rg"
  add_route             = true
}
clusters                       = []
cos                            = [
  {
    buckets        = [
      {
        endpoint_type = "public"
        force_delete  = true
        kms_key       = "slz-atracker-key"
        name          = "atracker-bucket"
        storage_class = "standard"
      }
    ]
    keys           = [
      {
        name        = "cos-bind-key"
        role        = "Writer"
        enable_HMAC = false
      }
    ]
    name           = "atracker-cos"
    plan           = "standard"
    resource_group = "slz-service-rg"
    use_data       = false
  }
  {
    buckets        = [
      {
        endpoint_type = "public"
        force_delete  = true
        kms_key       = "slz-slz-key"
        name          = "management-bucket"
        storage_class = "standard"
      }
      {
        endpoint_type = "public"
        force_delete  = true
        kms_key       = "slz-slz-key"
        name          = "workload-bucket"
        storage_class = "standard"
      }
    ]
    keys           = []
    name           = "cos"
    plan           = "standard"
    resource_group = "slz-service-rg"
    use_data       = false
  }
]
enable_transit_gateway         = true
key_management                 = {
  keys           = [
    {
      key_ring = "slz-slz-ring"
      name     = "slz-slz-key"
      root_key = true
    }
    {
      key_ring = "slz-slz-ring"
      name     = "slz-atracker-key"
      root_key = true
    }
    {
      key_ring = "slz-slz-ring"
      name     = "slz-vsi-volume-key"
      root_key = true
    }
  ]
  name           = "slz-slz-kms"
  resource_group = "slz-service-rg"
  use_hs_crypto  = false
}
resource_groups                = [
  {
    create = true
    name   = "slz-service-rg"
  }
  {
    create = true
    name   = "slz-management-rg"
  }
  {
    create = true
    name   = "slz-workload-rg"
  }
]
security_compliance_center     = {
  enable_scc        = false
  is_public         = false
  location_id       = "us"
  scope_name        = "slz-scope"
  scope_description = "slz-scope-description"
}
security_groups                = []
service_endpoints              = "private"
ssh_keys                       = [
  {
    name       = "slz-ssh-key"
    public_key = "<user ssh key value>"
  }
]
transit_gateway_connections    = ["management","workload"]
transit_gateway_resource_group = "slz-service-rg"
virtual_private_endpoints      = [
  {
    service_name   = "cos"
    service_type   = "cloud-object-storage"
    resource_group = "slz-service-rg"
    vpcs           = [
      {
        name    = "management"
        subnets = ["vpe-zone-1","vpe-zone-2","vpe-zone-3"]
      }
      {
        name    = "workload"
        subnets = ["vpe-zone-1","vpe-zone-2","vpe-zone-3"]
      }
    ]
  }
]
vpcs                           = [
  {
    default_security_group_rules = []
    flow_logs_bucket_name        = "management-bucket"
    network_acls                 = [
      {
        name  = "management-acl"
        rules = [
          {
            action      = "allow"
            destination = "10.0.0.0/8"
            direction   = "inbound"
            name        = "allow-ibm-inbound"
            source      = "161.26.0.0/16"
          }
          {
            action      = "allow"
            destination = "10.0.0.0/8"
            direction   = "inbound"
            name        = "allow-all-network-inbound"
            source      = "10.0.0.0/8"
          }
          {
            action      = "allow"
            destination = "0.0.0.0/0"
            direction   = "outbound"
            name        = "allow-all-outbound"
            source      = "0.0.0.0/0"
          }
        ]
      }
    ]
    prefix                       = "management"
    resource_group               = "slz-management-rg"
    subnets                      = {
      zone-1 = [
        {
          acl_name       = "management-acl"
          cidr           = "10.10.10.0/24"
          name           = "vsi-zone-1"
          public_gateway = false
        }
        {
          acl_name       = "management-acl"
          cidr           = "10.10.20.0/24"
          name           = "vpe-zone-1"
          public_gateway = false
        }
        {
          acl_name       = "management-acl"
          cidr           = "10.10.30.0/24"
          name           = "vpn-zone-1"
          public_gateway = false
        }
      ]
      zone-2 = [
        {
          acl_name       = "management-acl"
          cidr           = "10.20.10.0/24"
          name           = "vsi-zone-2"
          public_gateway = false
        }
        {
          acl_name       = "management-acl"
          cidr           = "10.20.20.0/24"
          name           = "vpe-zone-2"
          public_gateway = false
        }
      ]
      zone-3 = [
        {
          acl_name       = "management-acl"
          cidr           = "10.30.10.0/24"
          name           = "vsi-zone-3"
          public_gateway = false
        }
        {
          acl_name       = "management-acl"
          cidr           = "10.30.20.0/24"
          name           = "vpe-zone-3"
          public_gateway = false
        }
      ]
    }
    use_public_gateways          = {
      zone-1 = false
      zone-2 = false
      zone-3 = false
    }
  }
  {
    default_security_group_rules = []
    flow_logs_bucket_name        = "workload-bucket"
    network_acls                 = [
      {
        name  = "workload-acl"
        rules = [
          {
            action      = "allow"
            destination = "10.0.0.0/8"
            direction   = "inbound"
            name        = "allow-ibm-inbound"
            source      = "161.26.0.0/16"
          }
          {
            action      = "allow"
            destination = "10.0.0.0/8"
            direction   = "inbound"
            name        = "allow-all-network-inbound"
            source      = "10.0.0.0/8"
          }
          {
            action      = "allow"
            destination = "0.0.0.0/0"
            direction   = "outbound"
            name        = "allow-all-outbound"
            source      = "0.0.0.0/0"
          }
        ]
      }
    ]
    prefix                       = "workload"
    resource_group               = "slz-workload-rg"
    subnets                      = {
      zone-1 = [
        {
          acl_name       = "workload-acl"
          cidr           = "10.40.10.0/24"
          name           = "vsi-zone-1"
          public_gateway = false
        }
        {
          acl_name       = "workload-acl"
          cidr           = "10.40.20.0/24"
          name           = "vpe-zone-1"
          public_gateway = false
        }
      ]
      zone-2 = [
        {
          acl_name       = "workload-acl"
          cidr           = "10.50.10.0/24"
          name           = "vsi-zone-2"
          public_gateway = false
        }
        {
          acl_name       = "workload-acl"
          cidr           = "10.50.20.0/24"
          name           = "vpe-zone-2"
          public_gateway = false
        }
      ]
      zone-3 = [
        {
          acl_name       = "workload-acl"
          cidr           = "10.60.10.0/24"
          name           = "vsi-zone-3"
          public_gateway = false
        }
        {
          acl_name       = "workload-acl"
          cidr           = "10.60.20.0/24"
          name           = "vpe-zone-3"
          public_gateway = false
        }
      ]
    }
    use_public_gateways          = {
      zone-1 = false
      zone-2 = false
      zone-3 = false
    }
  }
]
vpn_gateways                   = [
  {
    connections    = []
    name           = "management-gateway"
    resource_group = "slz-management-rg"
    subnet_name    = "vpn-zone-1"
    vpc_name       = "management"
  }
]
vsi                            = [
  {
    boot_volume_encryption_key_name = "slz-vsi-volume-key"
    image_name                      = "ibm-ubuntu-18-04-6-minimal-amd64-2"
    machine_type                    = "cx2-4x8"
    name                            = "management-server"
    security_group                  = {
      name     = "management"
      rules    = [
        {
          direction = "inbound"
          name      = "allow-ibm-inbound"
          source    = "161.26.0.0/16"
        }
        {
          direction = "inbound"
          name      = "allow-vpc-inbound"
          source    = "10.0.0.0/8"
        }
        {
          direction = "outbound"
          name      = "allow-vpc-outbound"
          source    = "10.0.0.0/8"
        }
        {
          direction = "outbound"
          name      = "allow-ibm-tcp-53-outbound"
          source    = "161.26.0.0/16"
          tcp       = {
            port_max = 53
            port_min = 53
          }
        }
        {
          direction = "outbound"
          name      = "allow-ibm-tcp-80-outbound"
          source    = "161.26.0.0/16"
          tcp       = {
            port_max = 80
            port_min = 80
          }
        }
        {
          direction = "outbound"
          name      = "allow-ibm-tcp-443-outbound"
          source    = "161.26.0.0/16"
          tcp       = {
            port_max = 443
            port_min = 443
          }
        }
      ]
      vpc_name = "management"
    }
    ssh_keys                        = ["slz-ssh-key"]
    subnet_names                    = ["vsi-zone-1","vsi-zone-2","vsi-zone-3"]
    vpc_name                        = "management"
    vsi_per_subnet                  = 1
  }
  {
    boot_volume_encryption_key_name = "slz-vsi-volume-key"
    image_name                      = "ibm-ubuntu-18-04-6-minimal-amd64-2"
    machine_type                    = "cx2-4x8"
    name                            = "workload-server"
    security_group                  = {
      name     = "workload"
      rules    = [
        {
          direction = "inbound"
          name      = "allow-ibm-inbound"
          source    = "161.26.0.0/16"
        }
        {
          direction = "inbound"
          name      = "allow-vpc-inbound"
          source    = "10.0.0.0/8"
        }
        {
          direction = "outbound"
          name      = "allow-vpc-outbound"
          source    = "10.0.0.0/8"
        }
        {
          direction = "outbound"
          name      = "allow-ibm-tcp-53-outbound"
          source    = "161.26.0.0/16"
          tcp       = {
            port_max = 53
            port_min = 53
          }
        }
        {
          direction = "outbound"
          name      = "allow-ibm-tcp-80-outbound"
          source    = "161.26.0.0/16"
          tcp       = {
            port_max = 80
            port_min = 80
          }
        }
        {
          direction = "outbound"
          name      = "allow-ibm-tcp-443-outbound"
          source    = "161.26.0.0/16"
          tcp       = {
            port_max = 443
            port_min = 443
          }
        }
      ]
      vpc_name = "workload"
    }
    ssh_keys                        = ["slz-ssh-key"]
    subnet_names                    = ["vsi-zone-1","vsi-zone-2","vsi-zone-3"]
    vpc_name                        = "workload"
    vsi_per_subnet                  = 1
  }
]
wait_till                      = "IngressReady"