# TODO: Install solr with jetty
class features::solr {
  file { '/tmp/solr':
    ensure  => exists
  }
}