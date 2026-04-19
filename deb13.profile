config:
  cloud-init.user-data: |
    #cloud-config
    # Configuration des utilisateurs
    chpasswd:
      list: |
        root:root
        test:test
      expire: False

    users:
      - name: test
        groups: sudo
        shell: /bin/bash
        sudo: ['ALL=(ALL) NOPASSWD:ALL']
        lock_passwd: false

    packages:
      - openssh-server
      - git
      - curl
      - wget
      - locate
      - tcpdump
      - file
      - sudo
      - sshpass
      - ssh
      - jq
      - ncurses-term

    write_files:
      - path: /root/.profile
        permissions: '0600'
        defer: true
        append: true
        content: |
          export PATH=$HOME/.local/bin:$PATH

    runcmd:
      - |
        #!/bin/bash
        set -e
        export PATH="/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        export HOME=/root

        # Installation de fzf
        if [ ! -d "$HOME/.fzf" ]; then
          git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
          "$HOME/.fzf/install" --all
        fi

        # Installation de nushell
        curl -fsSL https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
        echo "deb https://apt.fury.io/nushell/ /" | tee /etc/apt/sources.list.d/fury.list
        apt update
        apt -y install nushell


    timezone: Europe/Paris
  limits.cpu: "2"
  limits.memory: 8GiB
description: cloud init profile with user test and root password
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
    pool: default
    size: 40GiB
    type: disk
name: hardening-profile
used_by: []
project: default
