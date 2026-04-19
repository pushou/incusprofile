config:
  cloud-init.user-data: |
    #cloud-config
    timezone: Europe/Paris
    package_update: true
    package_upgrade: true

    packages:
      - openssh-client
      - sshpass
      - ansible
      - ansible-lint
      - python3-pip
      - python3-jmespath
      - python3-cryptography
      - python3-netaddr
      - python3-argcomplete
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
      - ncurses-term
      - jq

    runcmd:
      - curl -fsSL https://apt.fury.io/nushell/gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
      - echo "deb https://apt.fury.io/nushell/ /" > /etc/apt/sources.list.d/fury.list
      - apt-get update
      - apt-get install -y nushell
      - git clone --depth 1 https://github.com/junegunn/fzf.git /root/.fzf
      - /root/.fzf/install --all
      - curl -LsSf https://astral.sh/uv/install.sh | sh
      - activate-global-python-argcomplete
description: Profile complet Ansible pour Debian 13
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
    size: 50GiB
    type: disk
name: ansible-profile
name: ansible
used_by: []
project: default
