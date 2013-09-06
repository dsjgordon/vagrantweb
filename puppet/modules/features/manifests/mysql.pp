# TODO: Install mysql
# TODO: Accept parameters to set slave and master details
class features::mysql {
  file { '/tmp/mysql':
    ensure  => exists
  }
}