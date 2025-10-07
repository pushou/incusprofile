config:
  cloud-init.user-data: |
    #cloud-config
    packages:
      - openssh-server
      - apache2
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
    mode: private
    name: eth0
    nictype: macvlan
    parent: enp0s31f6
    type: nic
  root:
    path: /
    pool: incus-storage-pool
    size: 50GiB
    type: disk
name: cloud-debian-macvlan
used_by: []
project: default
