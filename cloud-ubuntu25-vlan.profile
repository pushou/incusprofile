config:
  cloud-init.user-data: |
    #cloud-config
    packages:
      - openssh-server
      - auditd
      - audispd-plugins
    timezone: Europe/Paris
    package_upgrade: true
    package_update: true
    devices:
    agent:
      source: agent:config
      type: disk
description: cloud init profile
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: incusbr0
    type: nic
    vlan: "40"
  root:
    path: /
    pool: incus-storage-pool
    size: 30GiB
    type: disk
name: cloud-ubuntu25-vlan
used_by: []
project: default
