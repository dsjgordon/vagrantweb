class roles::utils {
  class { 'features::solr': }
  class { 'features::memcache': }
}