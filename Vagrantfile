VAGRANTFILE_API_VERSION = '2'
require 'JSON'

# Default VM Config.
# Copy example-config.json to config.json to override.
dev_config = {
	'vm_name'			=> 'vagrant',
	'ram'				=> false,
	'hostname'			=> false,
	'ssh_port'			=> 2222,
	'sync_folder'		=> false,
	'bootstrap'			=> false,
	'bridged_adapter'	=> false,
	'ip'				=> false,
	'host_port'			=> 8080,
	'app_environment'	=> 'development',
	'name'				=> 'developer',
	'email'				=> 'dev@example.com',
	'editor'			=> 'vi',
	'apt_update'		=> true
}

# Load optional config
if File.exists?('vagrant/config.json')
	File.open('vagrant/config.json', 'r') do |f|
		dev_config = dev_config.merge(JSON.load(f))
	end
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = 'precise64'
	config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210.box'

	if dev_config['sync_folder']
		config.vm.synced_folder './', dev_config['sync_folder'], id: "vagrant-root"
	else
		dev_config['sync_folder'] = '/vagrant'
	end

	# Port forwarding
	if dev_config['host_port']
		config.vm.network :forwarded_port, guest: 80, host: dev_config['host_port']
	end

	# Set hostname
	if dev_config['hostname']
		config.vm.hostname = dev_config['hostname']
	end

	# Ensure consistent SSH ports
	config.ssh.port = dev_config['ssh_port']

	# Virtualbox configuration
	config.vm.provider 'virtualbox' do |vb|
		# VM Name
		vb.name = dev_config['vm_name']

		# Memory
		if dev_config['ram']
			vb.customize ['modifyvm', :id, '--memory', dev_config['ram']]
		end

		# Add bridged adaptor for network ip
		if dev_config['bridged_adapter']
			vb.customize ['modifyvm', :id, '--nic2', 'bridged']
			vb.customize ['modifyvm', :id, '--bridgeadapter2', dev_config['bridged_adapter']]
		end
	end

	# Provision with puppet
	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = 'puppet/manifests'
		puppet.module_path = 'puppet/modules'
		puppet.manifest_file  = 'dev.pp'

		# Import vm config into puppet facts
		dev_config.each_pair do |key, value|
			puppet.facter["dev_#{key}"] = value
		end
		
		puppet.facter["fqdn"] = dev_config['hostname']
	end

	# Run developer bootstrap
	if dev_config['bootstrap']
		config.vm.provision :shell, :path => "vagrant/#{dev_config['bootstrap']}"
	end
end