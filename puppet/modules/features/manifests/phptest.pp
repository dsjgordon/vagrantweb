# TODO: Include PHP
# TODO: Install PHP unit
class features::phptest {
  file { '/tmp/phptest':
    ensure  => exists
  }
}