config:
  cloud-init.user-data: |
    #cloud-config
    packages:
      - openssh-server
      - make
      - build-essential
      - libssl-dev
      - zlib1g-dev
      - libbz2-dev
      - libreadline-dev
      - libsqlite3-dev
      - wget
      - curl
      - git
      - llvm
      - libncurses-dev
      - xz-utils
      - tk-dev
      - libxml2-dev
      - libxmlsec1-dev
      - libffi-dev
      - liblzma-dev
      - libssh-dev
      - python3-pip
description: cloud init profile
devices:
  agent:
    source: agent:config
    type: disk
  eth0:
    name: eth0
    nictype: bridged
    parent: incusbr0
    type: nic
  root:
    path: /
    pool: incus-storage-pool
    size: 50GiB
    type: disk
name: ansible
used_by: []
project: default
