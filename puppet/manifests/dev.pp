# Custom facts:
#
# $dev_vm_name
# $dev_hostname
# $dev_sync_folder
# $dev_bridged_adapter
# $dev_ip

# Set network interface
if $dev_bridged_adapter {
  if $dev_ip {
    network_config { 'eth1':
      ensure    => present,
      family    => 'inet',
      method    => 'static',
      netmask   => '255.255.255.0',
      ipaddress => $dev_ip,
      onboot    => 'true',
      options => {'pre-up' => 'sleep 2'}
    }
    ->
    exec { '/sbin/ifup eth1': }
  }
}

class { 'features::www':}
class { 'features::mysql': }
class { 'features::solr': }
class { 'features::memcache': }
class { 'features::git': }
class { 'features::minify': }
class { 'features::phptest': }