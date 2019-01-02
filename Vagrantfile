# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
export DEBIAN_FRONTEND=noninteractive

# add node key and repo
APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 1655A0AB68576280
apt-add-repository 'deb https://deb.nodesource.com/node_8.x bionic main'

# apt update and install
apt-get update
apt-get -qq install -y awscli nodejs postgresql

# use snap to install heroku
snap install --classic heroku
SCRIPT

VAGRANTFILE_API_VERSION = '2'
HOSTNAME = 'speed'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.shell = 'bash -c "BASH_ENV=/etc/profile exec bash"'
  config.vm.box = 'ubuntu/bionic64'
  config.vm.hostname = HOSTNAME
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.provider 'virtualbox' do |vb|
    vb.name = HOSTNAME
    vb.memory = 2048
  end
  config.vm.provision 'file', source: "#{ENV['HOME']}/.netrc",
                      destination: '.netrc'
  config.vm.provision 'shell', inline: $script
end
