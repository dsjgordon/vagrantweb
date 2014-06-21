class features::features_memcache {
    file { '/tmp/memcache':
        ensure  => exists
    }
}