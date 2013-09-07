class features::features_git ($name, $email, $editor) {
	class { 'git':
		template => 'features/gitconfig.erb',
		options => {
			'name'		=> $name,
			'email'		=> $email,
			'editor'	=> $editor
		}
	}
}