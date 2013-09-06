# Custom facts:
#
# // "bootstrap": "bootstrap.sh",
#  $dev_hostname: "darren.tom.dev",
#  $dev_ip: "172.16.5.50",
#  $dev_nameserver1: "194.168.4.100",
#  $dev_nameserver2: "8.8.8.8",
#  $dev_gateway: "192.168.1.1",
#  $dev_name: "Darren Gordon",
#  $dev_email: "dgordon@timesofmalta.com",
#  $dev_editor: "nano"

# TODO: Set ip etc

# Use host project path as www docroot
file { '/var/www/vagrant':
  ensure  => link,
  target  => '/vagrant'
}
->
class { 'features::www':
  domain  => $dev_hostname,
  docroot => '/var/www/vagrant'
}

# Set network interface
if $dev_ip {
  notify { "hmm": }
  network_config { 'eth1':
    ensure    => present,
    family    => 'inet',
    method    => 'static',
    netmask   => '255.255.255.0',
    ipaddress => $dev_ip,
    onboot    => 'true',
  }
  #->
  #network_route { 'default':
  #  ensure    => present,
  #  gateway   => $dev_gateway,
  #  interface => 'eth1',
  #  netmask   => '',
  #  network   => 'default'
  #}
}

class { 'features::mysql': }
class { 'features::solr': }
class { 'features::memcache': }
class { 'features::git': }
class { 'features::minify': }
class { 'features::phptest': }