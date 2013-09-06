# TODO: Install git
# TODO: Allow parameters to set git config defaults
class features::git {
  file { '/tmp/git':
    ensure  => exists
  }
}