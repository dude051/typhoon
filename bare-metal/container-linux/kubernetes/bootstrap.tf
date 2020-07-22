# Kubernetes assets (kubeconfig, manifests)
module "bootstrap" {
  source = "git::https://github.com/poseidon/terraform-render-bootstrap.git?ref=835890025bfb3499aa0cd5a9704e9e7d3e7e5fe5"

  cluster_name                    = var.cluster_name
  api_servers                     = [var.k8s_domain_name != "" ? var.k8s_domain_name : var.controllers.0.ipv4]
  etcd_servers                    = concat(var.controllers.*.ipv4, var.workers.*.ipv4)
  asset_dir                       = var.asset_dir
  networking                      = var.networking
  network_mtu                     = var.network_mtu
  network_ip_autodetection_method = var.network_ip_autodetection_method
  pod_cidr                        = var.pod_cidr
  service_cidr                    = var.service_cidr
  cluster_domain_suffix           = var.cluster_domain_suffix
  enable_reporting                = var.enable_reporting
  enable_aggregation              = var.enable_aggregation
}

