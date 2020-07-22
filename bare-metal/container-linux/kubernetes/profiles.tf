// Kubernetes Controller profiles
data "ct_config" "controller-ignitions" {
  count    = length(var.controllers)
  content  = data.template_file.controller-configs.*.rendered[count.index]
  strict   = true
  snippets = lookup(var.snippets, var.controllers.*.name[count.index], [])
}

data "template_file" "controller-configs" {
  count    = length(var.controllers)
  template = file("${path.module}/cl/controller.yaml")

  vars = {
    etcd_discovery         = var.etcd_discovery_url
    domain_name            = var.controllers.*.domain[count.index] != "" ? var.controllers.*.domain[count.index] : "{PRIVATE_IPV4}"
    etcd_name              = var.controllers.*.name[count.index]
    cluster_dns_service_ip = module.bootstrap.cluster_dns_service_ip
    cluster_domain_suffix  = var.cluster_domain_suffix
    ssh_authorized_key     = var.ssh_authorized_key
    dns                    = var.controllers.*.dns[count.index]
    address                = "${var.controllers.*.ipv4[count.index]}/${var.controllers.*.cidr[count.index]}"
    gateway                = var.controllers.*.gateway[count.index]
  }
}

// Kubernetes Worker profiles
data "ct_config" "worker-ignitions" {
  count    = length(var.workers)
  content  = data.template_file.worker-configs.*.rendered[count.index]
  strict   = true
  snippets = lookup(var.snippets, var.workers.*.name[count.index], [])
}

data "template_file" "worker-configs" {
  count = length(var.workers)

  template = file("${path.module}/cl/worker.yaml")

  vars = {
    etcd_discovery         = var.etcd_discovery_url
    domain_name            = var.workers.*.domain[count.index] != "" ? var.workers.*.domain[count.index] : "{PRIVATE_IPV4}"
    etcd_name              = var.workers.*.name[count.index]
    cluster_dns_service_ip = module.bootstrap.cluster_dns_service_ip
    cluster_domain_suffix  = var.cluster_domain_suffix
    ssh_authorized_key     = var.ssh_authorized_key
    node_labels            = join(",", lookup(var.worker_node_labels, var.workers.*.name[count.index], []))
    node_taints            = join(",", lookup(var.worker_node_taints, var.workers.*.name[count.index], []))
    dns                    = var.workers.*.dns[count.index]
    address                = "${var.workers.*.ipv4[count.index]}/${var.workers.*.cidr[count.index]}"
    gateway                = var.workers.*.gateway[count.index]
  }
}
