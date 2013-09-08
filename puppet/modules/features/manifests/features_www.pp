class features::features_www (
	$domain,
	$docroot
) {
	class { 'apache':
		default_vhost	=> false,
		mpm_module		=> prefork
	}

	include apache::mod::rewrite
	include apache::mod::php

	apache::vhost { "www.${domain}":
		vhost_name		=> '*',
		port			=> '80',
		docroot			=> $docroot,
		servername		=> $domain,
		docroot_group	=> 'www-data',
		docroot_owner	=> 'www-data',
		override		=> 'All'
	}

	class { 'php':
		noop => true
	}

	php::ini { 'php':
		value	=> [
			'display_errors	= "On"',
			'log_errors	= "On"',
			'error_reporting = E_ALL',
			'include_path = ".:/usr/share/php:./includes:/var/www/includes"',
			'date.timezone = "UTC"',
			'upload_max_filesize = 64M'
		],
		target  => 'php.ini',
		notify	=> Class['apache']
	}
}