VAGRANTFILE_API_VERSION = '2'
require 'JSON'

# Default VM Config.
# Copy example-config.json to config.json to override.
dev_config = {
    'vm_name'           => 'vagrant',
    'ram'               => false,
    'ssh_port'          => 2222,
    'sync_folder'       => false,
    'bootstrap'         => false,
    'bridged_adapter'   => false,
    'ip'                => false,
    'forward_ports'     => { 80 => 8080 },
    'name'              => 'developer',
    'email'             => 'dev@example.com',
    'editor'            => 'vi',
    'apt_update'        => true,
    'hostname'          => false,
    'app_environment'   => 'development',
    'www_docroot'       => false,
    'db_host'           => 'localhost',
    'db_port'           => '3306',
    'db_name'           => 'app',
    'db_username'       => 'root',
    'db_password'       => 'root',
    'memcache_host'     => 'localhost',
    'memcache_port'     => '11211'
}

# Load optional config
if File.exists?('vagrant/config.json')
    File.open('vagrant/config.json', 'r') do |f|
        dev_config = dev_config.merge(JSON.load(f))
    end
end

# Configure VM
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = 'saucy64'
    config.vm.box_url = 'http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-x64-virtualbox-puppet.box'

    if dev_config['sync_folder']
        config.vm.synced_folder './', dev_config['sync_folder'], id: "vagrant-root"
    else
        dev_config['sync_folder'] = '/vagrant'
    end

    # Port forwarding
    if dev_config['forward_ports']
        dev_config['forward_ports'].each_pair do |guest_port, host_port|
            config.vm.network :forwarded_port, guest: guest_port, host: host_port
        end
    end

    # Set hostname
    if dev_config['hostname']
        config.vm.hostname = dev_config['hostname']
    end

    # Ensure consistent SSH ports
    config.ssh.port = dev_config['ssh_port']

    if '2222' != dev_config['ssh_port']
        config.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh", disabled: "true"
        config.vm.network :forwarded_port, guest: 22, host: dev_config['ssh_port']
    end

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