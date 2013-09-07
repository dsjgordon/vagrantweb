# TODO: Install memcached and run as a service
class features::features_memcache {
  file { '/tmp/memcache':
    ensure  => exists
  }
}