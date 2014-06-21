# TODO: Include PHP
# TODO: Install PHP unit
class features::features_phptest {
    file { '/tmp/phptest':
        ensure  => exists
    }
}