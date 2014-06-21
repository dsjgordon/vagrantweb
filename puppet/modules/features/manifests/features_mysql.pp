class features::features_mysql (
    $port = "3306",
    $database = 'app',
    $username = 'root',
    $password = '',
    $pin_version = false
) {
    if !$pin_version or $pin_version == 'false' {
        $version = 'present'
    } else {
        $version = $pin_version
    }

    class { 'mysql':
        root_password   => $password,
        version         => $version
    }

    mysql::grant { $database:
        mysql_privileges    => 'ALL',
        mysql_db            => $database,
        mysql_user          => $username,
        mysql_password      => $password,
        mysql_host          => 'localhost',
    }
}