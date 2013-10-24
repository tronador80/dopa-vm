class stratodist(
  $basedir   = '/dopa-vm/stratosphere',
  $url   = 'http://dopa.dima.tu-berlin.de',
) {
    exec { 'get-binary':
        command => "/usr/bin/wget -r -nH --cut-dirs=5  --reject \"index.html*\" --no-parent ${url}/bin/stratosphere-dist/target/stratosphere-dist-0.4-SNAPSHOT-bin/stratosphere-0.4-SNAPSHOT -P ${basedir}; chmod u+x ${basedir}/bin/*",
        creates => "${basedir}/bin"
    }

    file { "${basedir}/log":
        ensure  => directory,
        owner   => 'vagrant',
        group   => 'www-data',
        mode    => '0755',
        require => Exec['get-binary'],
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
