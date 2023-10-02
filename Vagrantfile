# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider "libvirt" do |lv|
    lv.machine_type = "q35" # qemu-system-x86_64 -machine help

    # https://libvirt.org/formatdomain.html#bios-bootloader
    #libvirt.loader :readonly => yes, :secure => yes, :type => pflash, /usr/share/OVMF/OVMF_CODE.fd
    #nvram template='/usr/share/OVMF/OVMF_VARS.fd'>/var/lib/libvirt/nvram/guest_VARS.fd

    lv.cpus = 2
    lv.memory = 1024

    lv.disk_bus = "scsi"
    lv.disk_controller_model = "virtio-scsi"

    lv.graphics_type = "vnc"
    lv.video_type = "virtio"
  end

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
      dnf install -y puppet-agent
    SHELL

  config.vm.define "foreman" do |subconfig|
    subconfig.vm.provider "libvirt" do |lv|
      lv.cpus = 3
      lv.memory = 12288
    end

    subconfig.vm.box = "almalinux/8"
    #subconfig.vm.box = "generic/centos8s"
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
    end

    subconfig.vm.box = "almalinux/8"
    #subconfig.vm.box = "generic/centos8s"
    subconfig.vm.hostname = "katello.vagrant.local"
    subconfig.vm.network "private_network",
      :ip => "172.16.0.11",
      :libvirt__network_name => "provision",
      :libvirt__dhcp_enabled => false,
      :libvirt__forward_mode => "none"
  end
end