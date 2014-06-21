class features::features_memcache (
    $port = "11211",
    $pin_version = false
) {
    # Pin package version if specified
    if !$pin_version or $pin_version == 'false' {
        $version = 'present'
    } else {
        $version = $pin_version
    }
    
    class { 'memcached':
        max_memory      => 64,
        tcp_port        => $port,
        udp_port        => $port,
        package_ensure  => $version
    }
}