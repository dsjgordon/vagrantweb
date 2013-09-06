# TODO: Move everything into /vagrant.  Only need /puppet on a project with a production infrastructure
# TODO: Commit roles to a boilerplate project and remove
# TODO: Allow user to be specified in staging

VAGRANTFILE_API_VERSION = "2"
require 'JSON'

PROJECT = "lamp"
STAGING = {}

# Load staging
if File.exists?('vagrant/staging.json')
  File.open('vagrant/staging.json', 'r') do |f|
    STAGING = JSON.load(f)
  end
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box"

  # Port forwarding
  if STAGING['host_port']
    config.vm.network :forwarded_port, guest: 80, host: STAGING['host_port']
  elsif !STAGING['bridged_adapter']
    config.vm.network :forwarded_port, guest: 80, host: 8080
  end

  # Set hostname
  if STAGING['hostname']
    config.vm.hostname = STAGING['hostname']
  end

  # Ensure consistent SSH ports
  config.ssh.port = 2222

  # Virtualbox configuration
  config.vm.provider "virtualbox" do |vb|
    # VM Name
    if STAGING['vm_name']
      vb.name = STAGING['vm_name']
    else
      vb.name = PROJECT
    end

    # Memory
    if STAGING['ram']
      vb.customize ["modifyvm", :id, "--memory", STAGING['ram']]
    end

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

    if STAGING.length
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
  end

  # Run developer bootstrap
  if STAGING['bootstrap']
    config.vm.provision :shell, :path => "vagrant/#{STAGING['bootstrap']}"
  end
end