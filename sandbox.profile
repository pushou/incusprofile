config:
  limits.cpu: "2"
  limits.memory: "8GiB"
  cloud-init.user-data: |
    #cloud-config
    packages:
      - git
      - curl
      - wget
      - qemu-system
      - suricata
      - elfutils
      - locate
      - libguestfs-tools
      - xorriso
      - tcpdump
      - file
      - build-essential
      - ncurses-term
      - bash-completion
      - upx-ucl

    write_files:
      - path: /root/.profile
        permissions: '0600'
        defer: true
        append: true
        content: |
          export PATH=$HOME/.local/bin:$PATH
          export LIBGUESTFS_BACKEND=direct LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1
          export SANDBOXES='/root/projetm/sandboxes'

    runcmd:
      - |
        #!/bin/bash
        set -e
        export PATH="/root/.local/bin:/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        export HOME=/root


        # installation de nukunai
        git clone https://github.com/pushou/nukunai.git ~/nukunai

        # installation des extraits viraux
        git clone https://helga.circl.lu/NGSOTI/malware-dataset.git ~/malware-dataset

        # téléchargement de kunai
        wget -O /root/kunai https://github.com/kunai-project/kunai/releases/download/v0.6.2/kunai-amd64
        chmod +x /root/kunai

        # Installation de fzf avec réponse automatique
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        echo "yes" | ~/.fzf/install


        # Add Docker's official GPG key:
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        tee /etc/apt/sources.list.d/docker.sources <<EOF
        Types: deb
        URIs: https://download.docker.com/linux/debian
        Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
        Components: stable
        Signed-By: /etc/apt/keyrings/docker.asc
        EOF
        apt update
        apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        # Installation d'azazel
        cd /root
        git clone https://github.com/beelzebub-labs/azazel.git
        cd azazel
        sed -i -e 's/ -it//' -e 's/exec bash/make vmlinux;make generate;make build;exec bash/' Makefile
        make docker-dev
        make docker-dev-run
        cd /root/azazel
        docker compose up -d
        cd /root

        # installation de nushell
        curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
        echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
        apt update
        apt -y install nushell

        # Installation d'uv
        curl -LsSf https://astral.sh/uv/install.sh | sh

        # Installation de kunai-sandbox
        uv tool install https://github.com/kunai-project/sandbox.git

        # installation de nushell
        curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/fury-nushell.gpg
        echo "deb https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury.list
        apt update
        apt -y install nushell

        # prepare sandbox
        mkdir -p /root/projetm/sandboxes
        export SANDBOXES='/root/projetm/sandboxes'
        mkdir -p $SANDBOXES/sandbox1
        mkdir -p /root/images/debian
        curl -L --output /root/images/debian/debian-12-genericcloud-amd64.qcow2 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2

        # suricata update rules
        /usr/bin/suricata-update --no-test

        # probleme libguestfs
        echo "export LIBGUESTFS_BACKEND=direct LIBGUESTFS_DEBUG=1 LIBGUESTFS_TRACE=1"  >> /root/.bashrc
        
        # ajout magika pour la reconnaissance des types de fichiers
        curl -LsSf https://securityresearch.google/magika/install.sh | sh
     
        # completion docker
        if [ -f /usr/share/bash-completion/completions/docker ]; then
            echo "source /usr/share/bash-completion/completions/docker" >> /root/.bashrc
            echo "complete -o default docker" >> /root/bash.bashrc
        fi
        
        # term completion
        #cat << 'EOF' >> /etc/bash.bashrc

        # --- FIX COMPLETION & ALACRITTY ---
        # Si on est dans un shell interactif
        #if [ -z "$PS1" ]; then return; fi

        # Charger la complétion si elle existe
        #if [ -f /etc/bash_completion ]; then
        #    . /etc/bash_completion
        #fi

        # Correction pour le terminal Alacritty
        #export TERM=xterm-256color
        # ----------------------------------
        #EOF


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
    pool: default
    size: 20GiB
    type: disk
name: kunai-sandbox
used_by: []
project: default
