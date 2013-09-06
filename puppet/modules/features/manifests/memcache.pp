# TODO: Install memcached and run as a service
class features::memcache {
  file { '/tmp/memcache':
    ensure  => exists
  }
}