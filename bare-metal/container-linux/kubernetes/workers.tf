resource "libvirt_volume" "worker-root" {
  count = length(var.workers)

  name           = "${var.cluster_name}-${var.workers.*.name[count.index]}-root"
  base_volume_id = libvirt_volume.kube_base.id
  pool           = libvirt_pool.kube_pool.name
}

resource "libvirt_ignition" "worker" {
  count = length(var.workers)

  name    = "${var.cluster_name}-${var.workers.*.name[count.index]}-ign"
  content = data.ct_config.worker-ignitions.*.rendered[count.index]
}

resource "libvirt_domain" "worker" {
  count = length(var.workers)

  qemu_agent = true
  autostart  = true
  name       = var.workers.*.name[count.index]
  vcpu       = var.worker_vcpu
  memory     = var.worker_memory
  running    = true

  coreos_ignition = libvirt_ignition.worker.*.id[count.index]

  disk {
    volume_id = libvirt_volume.worker-root.*.id[count.index]
  }

  network_interface {
    network_id     = libvirt_network.kube_network.id
    hostname       = var.workers.*.name[count.index]
    wait_for_lease = true
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
}
