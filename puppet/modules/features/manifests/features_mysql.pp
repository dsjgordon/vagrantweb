class features::features_mysql (
	$database = 'db1',
	$root_user = 'root',
	$root_password = 'root'
) {
	class { 'mysql':
		root_password	=> $root_password
	}

	mysql::grant { $database:
		mysql_privileges	=> 'ALL',
		mysql_db			=> $database,
		mysql_user			=> $root_user,
		mysql_password		=> $root_password,
		mysql_host			=> 'localhost',
	}
}