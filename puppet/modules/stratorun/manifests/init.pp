class stratorun(
  $basedir   = '/dopa-vm/',
  $url   = 'http://dopa.dima.tu-berlin.de',
) {
	exec { 'get-binary':
        command => "/usr/bin/wget -r -nH --cut-dirs=4  --reject \"index.html*\" --no-parent http://dopa.dima.tu-berlin.de/bin/stratosphere-dist/target/stratosphere-dist-0.3-bin/stratosphere-0.3/ -P /dopa-vm/bin; chmod u+x /dopa-vm/bin/stratosphere-0.3/bin/*",
		creates => "/dopa-vm/bin"
    }

    file { '/dopa-vm/bin/stratosphere-0.3/log':
        ensure  => directory,
        owner   => 'vagrant',
        group   => 'www-data',
        mode    => '0755',
        require => Exec['get-binary'],
    }

    exec { 'start-local':        
        command => "/dopa-vm/bin/stratosphere-0.3/bin/start-local.sh",
        require => File['/dopa-vm/bin/stratosphere-0.3/log'],
    }

    exec { 'start-web':        
        command => "/dopa-vm/bin/stratosphere-0.3/bin/start-pact-web.sh",
        require => Exec['start-local'],
    }
}
