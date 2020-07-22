resource "libvirt_volume" "controller-root" {
  count = length(var.controllers)

  name           = "${var.cluster_name}-${var.controllers.*.name[count.index]}-root"
  base_volume_id = libvirt_volume.kube_base.id
  pool           = libvirt_pool.kube_pool.name
}

resource "libvirt_ignition" "controller" {
  count = length(var.controllers)

  name    = "${var.cluster_name}-${var.controllers.*.name[count.index]}-ign"
  content = data.ct_config.controller-ignitions.*.rendered[count.index]
}

resource "libvirt_domain" "controller" {
  count = length(var.controllers)

  qemu_agent = true
  autostart  = true
  name       = var.controllers.*.name[count.index]
  vcpu       = var.controller_vcpu
  memory     = var.controller_memory
  running    = true

  coreos_ignition = libvirt_ignition.controller.*.id[count.index]

  disk {
    volume_id = libvirt_volume.controller-root.*.id[count.index]
  }

  network_interface {
    network_id     = libvirt_network.kube_network.id
    hostname       = var.controllers.*.name[count.index]
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}
