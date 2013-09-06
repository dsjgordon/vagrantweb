# TODO: Move everything into /vagrant.  Only need /puppet on a project with a production infrastructure
# TODO: Commit roles to a boilerplate project and remove
# TODO: Allow user to be specified in VM_CONFIG
# TODO: Configure .gitconfig
# TODO: Configure nameserver
# TODO: Configure gateway
# TODO: Configure default user
# TODO: Configure mount folder

VAGRANTFILE_API_VERSION = "2"
require 'JSON'

PROJECT = "lamp"

# Default VM Config.
# Copy example-config.json to config.json to override.
VM_CONFIG = {
  "vm_name"         => PROJECT,
  "ram"             => false,
  "hostname"        => false,
  "ssh_port"        => 2222,
  "bootstrap"       => false,
  "bridged_adapter" => false,
  "ip"              => false,
  "host_port"       => 8080
}

# Load optional config
if File.exists?('vagrant/config.json')
  File.open('vagrant/config.json', 'r') do |f|
    VM_CONFIG.merge(JSON.load(f))
  end
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  # Port forwarding
  if VM_CONFIG['host_port']
    config.vm.network :forwarded_port, guest: 80, host: VM_CONFIG['host_port']
  end

  # Set hostname
  if VM_CONFIG['hostname']
    config.vm.hostname = VM_CONFIG['hostname']
  end

  # Ensure consistent SSH ports
  config.ssh.port = VM_CONFIG['ssh_port']

  # Virtualbox configuration
  config.vm.provider "virtualbox" do |vb|
    # VM Name
    vb.name = VM_CONFIG['vm_name']

    # Memory
    if VM_CONFIG['ram']
      vb.customize ["modifyvm", :id, "--memory", VM_CONFIG['ram']]
    end

    # Add bridged adaptor for network ip
    if VM_CONFIG['bridged_adapter']
      vb.customize ["modifyvm", :id, "--nic2", "bridged"]
      vb.customize ["modifyvm", :id, "--bridgeadapter2", VM_CONFIG['bridged_adapter']]
    end
  end

  # Install Librarian-puppet to manage third party modules
  config.vm.provision :shell, :path => "vagrant/librarian-puppet.sh"

  # Provision with puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "dev.pp"

    # Import vm config into puppet facts
    puppet.factor = {}
    VM_CONFIG.each_pair do |key, value|
      puppet.facter["dev_#{key}"] = value
    end
  end

  # Run developer bootstrap
  if VM_CONFIG['bootstrap']
    config.vm.provision :shell, :path => "vagrant/#{VM_CONFIG['bootstrap']}"
  end
end