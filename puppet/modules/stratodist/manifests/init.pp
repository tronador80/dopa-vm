class stratodist(
  $basedir   = '/dopa-vm/stratosphere',
  $url   = 'http://dopa.dima.tu-berlin.de',
) {
	require git

    @git::clone { 'TU-Berlin/dopa-binaries':
    directory => $basedir,
    }

    file { "${basedir}/log":
        ensure  => directory,
        owner   => 'vagrant',
        group   => 'www-data',
        mode    => '0755',
        require => Git::Clone['TU-Berlin/dopa-binaries'],
    }

    package { 'bc':
      ensure => present,
      before => Exec['start-local'],
    }

    exec { 'start-local':        
        command => "${basedir}/bin/start-local.sh",
        require => File["${basedir}/log"],
    }

    exec { 'start-web':        
        command => "${basedir}/bin/start-pact-web.sh",
        require => Exec['start-local'],
    }

    exec { 'start-sopremo':        
        command => "${basedir}/bin/start-sopremo-server.sh",
        require => Exec['start-local'],
    }

    exec { 'start-meteor':        
        command => "${basedir}/bin/meteor-webfrontend.sh start",
        require => Exec['start-sopremo'],
    }

}
