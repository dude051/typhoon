resource "libvirt_volume" "kube_base" {
  name   = "${var.cluster_name}-base"
  source = var.os_image
  pool   = libvirt_pool.kube_pool.name
}

resource "libvirt_pool" "kube_pool" {
  name = var.cluster_name
  type = "dir"
  path = "${var.libvirt_pool}-${var.cluster_name}"
}

resource "libvirt_network" "kube_network" {
  name      = var.cluster_name
  mode      = "bridge"
  bridge    = var.bridge_device
  autostart = var.network_autostart
}
