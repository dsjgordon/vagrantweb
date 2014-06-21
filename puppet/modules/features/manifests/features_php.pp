class features::features_php (
    $debug = false,
    $pin_version = false,
    $docroot
) {
    # Pin package version if specified
    if !$pin_version or $pin_version == 'false' {
        $version = 'present'
    } else {
        $version = $pin_version
    }

    include apache::mod::php

    # PHP
    class { 'php':
        noop    => true,
        version => $version
    }

    # Modules
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
            "include_path = \".:/usr/share/php:./includes:${docroot}/includes\"",
            'date.timezone = "UTC"',
            'upload_max_filesize = 64M'
        ],
        target  => 'php.ini',
        notify  => Class['apache']
    }
    
    if $docroot and $docroot != 'false' {
        file { "${docroot}/phpinfo.php":
            content => "<?php\nphpinfo();"
        }
    }
}