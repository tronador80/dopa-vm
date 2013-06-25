# == Class: git
#
# Base class for using Puppet to clone and manage Git repositories.
#
class git( 
	$urlformat = 'https://github.com/%s.git',
) {
	package { 'git':
		ensure  => latest,
	}

	package { 'git-review':
		ensure   => latest,
	}

	Git::Clone <| |>
}
