# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider "libvirt" do |lv|
    lv.machine_type = "q35" # qemu-system-x86_64 -machine help

    lv.cpus = 2
    lv.memory = 1024

    lv.disk_bus = "scsi"
    lv.disk_controller_model = "virtio-scsi"

    lv.graphics_type = "vnc"
    lv.video_type = "virtio"
  end

  config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: [".git/", ".r10k/", "modules/"],
    rsync__args: ["--verbose", "--archive", "-z", "--copy-links"]

  config.vm.provision "make bigger", type: "shell",
    privileged: true,
    inline: <<-SHELL
      dnf install -y cloud-utils-growpart

      # Figure out which partition root is on. (UEFI it's 2)
      if [[ $(lsblk --noheadings --list -o NAME,FSTYPE,MOUNTPOINT) \
            =~ sda([[:digit:]])[[:space:]]+xfs[[:space:]]+\/ ]]; then
        growpart /dev/sda ${BASH_REMATCH[1]}
        xfs_growfs /dev/sda${BASH_REMATCH[1]}
      fi
    SHELL

  config.vm.provision "puppet install", type: "shell",
    privileged: true,
    inline: <<-SHELL
      source /etc/os-release
      distro_major_version=${VERSION_ID%.*}
      distro_minor_version=${VERSION_ID#*.}

      if [[ $distro_major_version -eq "8" ]]; then
        dnf module enable -y postgresql:12
        dnf module enable -y ruby:2.7
      fi

      rpm -Uvh https://yum.puppet.com/puppet7-release-el-${distro_major_version}.noarch.rpm
      dnf install -y git puppet-agent
      /opt/puppetlabs/puppet/bin/gem install r10k -v '<4'
    SHELL

  config.vm.provision "puppet modules", type: "shell",
    privileged: false,
    keep_color: true,
    inline: <<-SHELL
      cd /vagrant
      /opt/puppetlabs/puppet/bin/r10k --verbose=info puppetfile install
    SHELL

  config.vm.provision "puppet apply", type: "shell",
    privileged: false,
    keep_color: true,
    inline: <<-SHELL
      cd /vagrant
      sudo /opt/puppetlabs/bin/puppet apply --modulepath site-modules:modules --hiera_config=hiera.yaml --graph --graphdir graphs manifests/site.pp
    SHELL

  config.vm.define "foreman" do |subconfig|
    subconfig.vm.provider "libvirt" do |lv|
      lv.cpus = 3
      lv.memory = 12288

      # https://libvirt.org/formatdomain.html#bios-bootloader
      lv.loader = '/usr/share/OVMF/OVMF_CODE.secboot.fd'
      lv.nvram = '/usr/share/OVMF/OVMF_VARS.secboot.fd'
    end

    subconfig.vm.provision "foreman ansible", type: "ansible",
      compatibility_mode: "2.0", playbook: "ansible/foreman.yml"

    subconfig.vm.box = "almalinux/8.uefi"
    subconfig.vm.hostname = "foreman.vagrant.local"
    subconfig.vm.network "private_network",
      :ip => "172.16.0.10",
      :libvirt__network_name => "provision",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
  end

  config.vm.define "katello" do |subconfig|
    subconfig.vm.provider "libvirt" do |lv|
      lv.cpus = 4
      lv.memory = 20480
      lv.machine_virtual_size = 60
    end

    subconfig.vm.provision "foreman ansible", type: "ansible",
      compatibility_mode: "2.0", playbook: "ansible/foreman.yml"

    subconfig.vm.box = "almalinux/8"
    subconfig.vm.hostname = "katello.vagrant.local"
    subconfig.vm.network "private_network",
      :ip => "172.16.0.11",
      :libvirt__network_name => "provision",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
  end

  config.vm.define "installer" do |subconfig|
    subconfig.vm.provider "libvirt" do |lv|
      lv.cpus = 4
      lv.memory = 20480
      lv.machine_virtual_size = 60
    end

    subconfig.vm.box = "almalinux/8"
    subconfig.vm.hostname = "installer.vagrant.local"
    subconfig.vm.network "private_network",
      :ip => "172.16.0.12",
      :libvirt__network_name => "provision",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
  end
end
