class features::features_www (
    $domain,
    $docroot,
    $debug = false,
    $pin_version = false,
    $server_admin = undef,
    $env = []
) {
    # Pin package version if specified
    if !$pin_version or $pin_version == 'false' {
        $package_ensure = 'present'
    } else {
        $package_ensure = $pin_version
    }
    
    # Apache
    # Prefork MPM is needed for php
    class { 'apache':
        default_vhost   => false,
        mpm_module      => prefork,
        default_mods    => [
            'alias',
            'auth_basic',
            'authn_default',
            'authz_default',
            'authz_groupfile',
            'authz_user',
            'deflate',
            'dir',
            'env',
            'mime',
            'negotiation',
            'reqtimeout',
            'rewrite',
            'setenvif'
        ],
        serveradmin     => $server_admin,
        package_ensure  => $package_ensure
    }

    include apache::mod::rewrite
    include apache::mod::php

    define features::vhost (
        $ssl
    ) {
        if !$ssl {
            $port = '80'
        } else {
            $port = '443'
        }

        apache::vhost { $name:
            vhost_name  => '*',
            port        => $port,
            ssl         => $ssl,
            docroot     => $features::features_www::docroot,
            directories => {
                path        => $features::features_www::docroot,
                options     => ['FollowSymLinks'] 
            },
            servername  => $features::features_www::domain,
            override    => 'All',
            setenv      => $features::features_www::env
        }
    }
    features::vhost { "www.${domain}":
        ssl => false
    }
    features::vhost { "www.${domain}-ssl":
        ssl => true
    }

    # PHP
    class { 'php':
        noop => true
    }

    package { 'curl':
        ensure => 'installed'
    }

    php::module { [ 'curl', 'memcache', 'mysql' ]: }
    
    php::module { 'apc':
        module_prefix => 'php-'
    }
    
    if $debug {
        php::module { 'xdebug': }
    }

    php::ini { 'php':
        value   => [
            'display_errors = "On"',
            'log_errors = "On"',
            'error_reporting = E_ALL',
            'include_path = ".:/usr/share/php:./includes:/var/www/includes"',
            'date.timezone = "UTC"',
            'upload_max_filesize = 64M'
        ],
        target  => 'php.ini',
        notify  => Class['apache']
    }
}