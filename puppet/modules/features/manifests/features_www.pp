class features::features_www (
    $domain,
    $docroot,
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
            'authn_core',
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
}