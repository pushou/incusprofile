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
      - tcpdump
      - ssh
    runcmd:
      - |
        #!/bin/bash
        set -e
        # Installation de networklab
        sudo python3 -m pip install networklab --break-system-packages

        # Installation des dépendances pour netlab (ubuntu, ansible)
        sudo netlab install -y ubuntu ansible containerlab

        # Clonage du dépôt bgplab dans /root/bgplab
        sudo git clone https://github.com/bgplab/bgplab.git /root/bgplab
        sudo git clone https://github.com/ipspace/netlab-examples.git /root/netlab-examples
        sudo docker image pull registry.iutbeziers.fr/ceos:4.33.1F

        # Installation de fzf avec réponse automatique
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        echo "yes" | ~/.fzf/install

    # Définition du fuseau horaire
    timezone: Europe/Paris
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
name: netlab
used_by: []
project: default
