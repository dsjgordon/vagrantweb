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

    php::module { [ 'curl', 'memcache', 'mysql', 'json' ]: }

    php::module { 'apc':
        module_prefix => 'php-'
    }

    if $debug {
        php::module { 'xdebug': }
        class { 'composer':
            command_name    => 'composer',
            target_dir      => '/usr/local/bin'
        }

        if $docroot and $docroot != 'false' {
            file { "${docroot}/phpinfo.php":
                content => "<?php\nphpinfo();"
            }
        }
    }

    if str2bool("$debug") {
        $display_errors = "On"
    }
    else {
        $display_errors = "Off"
    }

    php::ini { 'php':
        value   => [
            "display_errors = \"${display_errors}\"",
            'log_errors = "On"',
            'error_reporting = E_ALL',
            "include_path = \".:/usr/share/php:./includes:${docroot}/includes\"",
            'date.timezone = "UTC"',
            'upload_max_filesize = 64M'
        ],
        target  => 'php.ini',
        notify  => Class['apache']
    }
}