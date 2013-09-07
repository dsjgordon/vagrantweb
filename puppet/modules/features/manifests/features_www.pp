# TODO: Include Features::PHP
class features::features_www ( $domain, $docroot) {
	class { 'apache':
		# default_mods  => ['rewrite', 'alias', 'auth_digest', 'authn_file', 'headers', 'mime', 'deflate', 'env'],
		# 'cgi', 'deflate',
	}

	apache::vhost { "www.${domain}":
		vhost_name    => '*',
		port          => '80',
		docroot       => $docroot,
		servername    => "www.${domain}",
		serveraliases => ["admin.${domain}", "app.${domain}"]
	}
}