class vagrant_dev {
    # Set network interface
    if $dev_bridged_adapter {
        if $dev_ip {
            network_config { 'eth1':
                ensure      => present,
                family      => 'inet',
                method      => 'static',
                netmask     => '255.255.255.0',
                ipaddress   => $dev_ip,
                onboot      => 'true',
                options     => {'pre-up' => 'sleep 2'}
            }
            ->
            exec { '/sbin/ifup eth1': }
        }
    }
    
    # PHP frontend
    class { 'features::features_www':
        domain          => $dev_hostname,
        docroot         => $dev_sync_folder,
        debug           => true,
        server_admin    => $dev_email,
        env             => "APP_ENVIRONMENT ${dev_app_environment}"
    }
    file { "${dev_sync_folder}/phpinfo.php":
        content => '<?php\nphpinfo();'
    }
    
    # Mysql
    class { 'features::features_mysql': }
    
    # Git
    class { 'features::features_git':
        name    => $dev_name,
        email   => $dev_email,
        editor  => $dev_editor
    }
    
    # Build tools
    package { 'build-essential':
        ensure => 'installed'
    }

    # TODO:
    class { 'features::features_memcache': }
    class { 'features::features_phptest': }
}

# Ensure apt is up to date, then run
if $dev_apt_update and 'false' != $dev_apt_update {
    exec { 'apt-get update':
        path    => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
        command => 'apt-get -q -y update',
    }
    ->
    class { 'vagrant_dev': }
}
else {
    class { 'vagrant_dev': }
}