# TODO: Include Features::PHP
# TODO: Install apache
# TODO: Set up www, local sudoer and deploy users
# TODO: Accept parameters to set up master (cron jobs)
#
class features::www ( $domain, $docroot) {
  class { 'apache':
    # default_mods  => ['rewrite', 'alias', 'auth_digest', 'authn_file', 'headers', 'mime', 'deflate', 'env'],
    # 'cgi', 'deflate',
  }
  
  apache::vhost { "www.${domain}":
    vhost_name    => '*',
    port          => '80',
    docroot       => $docroot,
    servername    => "www.${domain}",
    serveraliases => ["admin.${domain}", "app.${domain}"]
  }
}