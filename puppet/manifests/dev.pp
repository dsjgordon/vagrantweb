class vagrant_dev {
    # Vagrant infrastructure
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
    
    # Apache
    class { 'features::features_www':
        domain          => $dev_hostname,
        docroot         => $dev_sync_folder,
        server_admin    => $dev_email,
        env             => [
            "APP_ENVIRONMENT ${dev_app_environment}",
            "APP_DB_HOST ${dev_db_host}",
            "APP_DB_PORT ${dev_db_port}",
            "APP_DB_USERNAME ${dev_db_username}",
            "APP_DB_PASSWORD ${dev_db_password}",
            "APP_DB_NAME ${dev_db_name}",
            "APP_MEMCACHE_HOST ${dev_memcache_host}",
            "APP_MEMCACHE_PORT ${dev_memcache_port}"
        ]
    }
    
    # PHP
    class { 'features::features_php':
        debug   => true,
        docroot => $dev_sync_folder
    }
    
    # Mysql
    class { 'features::features_mysql':
        port        => $dev_db_port,
        username    => $dev_db_username,
        password    => $dev_db_password,
        database    => $dev_db_name
    }
    
    # Memcache
    class { 'features::features_memcache':
        port    => $dev_memcache_port
    }
    
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