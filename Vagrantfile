# TODO: Make this work without staging.json with sane defaults (forward to 8080, etc)
# TODO: Move everything into /vagrant.  Only need /puppet on a project with a production infrastructure
# TODO: Commit roles to a boilerplate project and remove

VAGRANTFILE_API_VERSION = "2"
require 'JSON'

PROJECT = "lamp"

# Load staging
if File.exists?('vagrant/staging.json')
  File.open('vagrant/staging.json', 'r') do |f|
    STAGING = JSON.load(f)
  end
  
  %w(hostname ip).each do |k|
    raise "vagrant/staging.json must have #{k} set" unless (STAGING.has_key?(k) and !STAGING[k].nil?)
  end
else
  raise "You need to copy vagrant/base-staging.json to staging.json and edit it"
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"
  
  # Networking
  config.vm.network :forwarded_port, guest: 80, host: 80
  
  # Set hostname
  config.vm.hostname = STAGING['hostname']
  
  # Ensure consistent SSH ports
  config.ssh.port = 2222
  
  # Virtualbox configuration
  config.vm.provider "virtualbox" do |vb|
    vb.name = PROJECT
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    
    # Add bridged adaptor for network ip
    if STAGING['bridged_adapter']
      vb.customize ["modifyvm", :id, "--nic2", "bridged"]
      vb.customize ["modifyvm", :id, "--bridgeadapter2", STAGING['bridged_adapter']]
    end
  end
  
  # Install Librarian-puppet to manage third party modules
  config.vm.provision :shell, :path => "vagrant/librarian-puppet.sh"
  
  # Provision with puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "dev.pp"
    
    puppet.facter = {
      "dev_hostname"    => STAGING["hostname"],
      "dev_ip"          => STAGING["ip"],
      "dev_gateway"     => STAGING["gateway"],
      "dev_nameserver"  => STAGING["nameserver"],
      "dev_name"        => STAGING["name"],
      "dev_email"       => STAGING["email"],
      "dev_editor"      => STAGING["editor"]
    }
  end
  
  # Run developer bootstrap
  if STAGING['bootstrap']
    config.vm.provision :shell, :path => STAGING['bootstrap']
  end
end