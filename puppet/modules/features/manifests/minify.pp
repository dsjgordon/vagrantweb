# TODO: Install node.js, less and uglify
class features::minify {
  file { '/tmp/minify':
    ensure  => exists
  }
}