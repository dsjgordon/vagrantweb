class features::features_mysql {
	file { '/tmp/mysql':
		ensure  => exists
	}
}