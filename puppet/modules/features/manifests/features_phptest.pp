class features::features_phptest (
    $phar_uri = 'https://phar.phpunit.de/phpunit.phar',
    $install_path = '/usr/local/bin/phpunit'
) {
      include wget

      wget::fetch { 'phpunit-phar-wget':
        source      => $phar_uri,
        destination => $install_path,
        verbose     => false
      }
      ->
      file { 'phpunit-phar':
        ensure  => 'present',
        mode    => 'a+x',
        path    => $install_path
      }
}