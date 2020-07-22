variable "cluster_name" {
  type        = string
  description = "Unique cluster name"
}

# libvirt

variable "os_image" {
  type        = string
  description = "Location of OS image to provision volumes with."
}

variable "libvirt_pool" {
  type        = string
  description = "Location of where to create libvirt directory pool to store volumes"
  default     = "/var/lib/libvirt/images"
}

variable "bridge_device" {
  type        = string
  description = "The bridge device defines the name of a bridge device which will be used to construct the virtual network"
  default     = "br0"
}

variable "network_autostart" {
  type        = bool
  description = "Set to false to not start the network on host boot up."
  default     = true
}

variable "controller_vcpu" {
  description = "Number of vCPUs to allocate for each controller"
  type        = string
  default     = 2
}

variable "controller_memory" {
  description = "Amount of RAM to allocate in MiB for each controller"
  type        = string
  default     = 2048
}

variable "worker_vcpu" {
  description = "Number of vCPUs to allocate for each worker"
  type        = string
  default     = 10
}

variable "worker_memory" {
  description = "Amount of RAM to allocate in MiB for each worker"
  type        = string
  default     = 4096
}

# machines

variable "etcd_discovery_url" {
  type        = string
  description = "Discovery URL used for etcd clustering."
}

variable "controllers" {
  type = list(object({
    name    = string
    domain  = string
    ipv4    = string
    cidr    = string
    dns     = string
    gateway = string
  }))
  description = <<EOD
Optional list of controller machine details (unique name, FQDN and IP)
[{ name = "node1", domain = "node1.example.com", ipv4 = "192.168.100.50}]
EOD
  default = [{
    name    = "node1"
    domain  = ""
    ipv4    = ""
    cidr    = ""
    dns     = ""
    gateway = ""
  }]
}

variable "workers" {
  type = list(object({
    name    = string
    domain  = string
    ipv4    = string
    cidr    = string
    dns     = string
    gateway = string
  }))
  description = <<EOD
Optional list of worker machine details (unique name and FQDN)
[
  { name = "node2", domain = "node2.example.com", ipv4 = "192.168.100.51},
  { name = "node3", domain = "node3.example.com", ipv4 = "192.168.100.52}
]
EOD
  default = [
    {
      name    = "node2"
      domain  = ""
      ipv4    = ""
      cidr    = ""
      dns     = ""
      gateway = ""
    },
    {
      name   = "node3"
      domain = ""
      ipv4   = ""
      cidr    = ""
      dns     = ""
      gateway = ""
    }
  ]
}

variable "snippets" {
  type        = map(list(string))
  description = "Map from machine names to lists of Container Linux Config snippets"
  default     = {}
}

variable "worker_node_labels" {
  type        = map(list(string))
  description = "Map from worker names to lists of initial node labels"
  default     = {}
}

variable "worker_node_taints" {
  type        = map(list(string))
  description = "Map from worker names to lists of initial node taints"
  default     = {}
}

# configuration

variable "k8s_domain_name" {
  type        = string
  description = "Optional controller DNS name which resolves to a controller instance. Workers and kubeconfig's will communicate with this endpoint (e.g. cluster.example.com). If not set, will use IP address of first controller."
  default     = ""
}

variable "ssh_authorized_key" {
  type        = string
  description = "SSH public key for user 'core'"
}

variable "networking" {
  type        = string
  description = "Choice of networking provider (flannel or calico)"
  default     = "calico"
}

variable "network_mtu" {
  type        = number
  description = "CNI interface MTU (applies to calico only)"
  default     = 1480
}

variable "network_ip_autodetection_method" {
  type        = string
  description = "Method to autodetect the host IPv4 address (applies to calico only)"
  default     = "first-found"
}

variable "pod_cidr" {
  type        = string
  description = "CIDR IPv4 range to assign Kubernetes pods"
  default     = "10.2.0.0/16"
}

variable "service_cidr" {
  type        = string
  description = <<EOD
CIDR IPv4 range to assign Kubernetes services.
The 1st IP will be reserved for kube_apiserver, the 10th IP will be reserved for coredns.
EOD
  default     = "10.3.0.0/16"
}

# optional

variable "enable_reporting" {
  type        = bool
  description = "Enable usage or analytics reporting to upstreams (Calico)"
  default     = false
}

variable "enable_aggregation" {
  type        = bool
  description = "Enable the Kubernetes Aggregation Layer (defaults to false)"
  default     = false
}

# unofficial, undocumented, unsupported

variable "asset_dir" {
  type        = string
  description = "Absolute path to a directory where generated assets should be placed (contains secrets)"
  default     = ""
}

variable "cluster_domain_suffix" {
  type        = string
  description = "Queries for domains with the suffix will be answered by coredns. Default is cluster.local (e.g. foo.default.svc.cluster.local) "
  default     = "cluster.local"
}

