# == Roles for DOPA-VM
#
# A 'role' represents a set of software configurations required for
# giving this machine some special function.
#
# To enable a particular role on your instance, include it in the
# mediawiki-vagrant node definition in 'site.pp'.
#


# == Class: role::generic
# Configures common tools and shell enhancements.
class role::generic {
	class { 'misc': }
	class { 'oraclejava':
		version => "7",
		isdefault => true,
	}
}


# == Class: role::stratosphere
# Provisions a Stratosphere instance powered by Oracle Java.
class role::strat-src {
	include role::generic
	class { 'git': }
	$ozoneDir = '/dopa-vm/stratosphere'
	$meteorDir = '/dopa-vm/meteor'

	@git::clone { 'TU-Berlin/ozone':
	directory => $ozoneDir,
	}

	@git::clone { 'TU-Berlin/ozone-meteor':
	directory => $meteorDir,
	}

}
# == Class: role::stratosphere
# Provisions a Stratosphere instance powered by Oracle Java.
class role::strat-bin {
	include role::generic
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
# == Class: role::cdh4pseudo
# Provisions a pseudo distributes Cloudera 4 instanstace.
#class role::cdh4pseudo {
#	include role::generic
#	include stdlib
#	include cdh4pseudo

#	file { '/home/vagrant/restart_hbase_master.sh':
#		ensure => present,
#		mode   => '0755',
#		source => 'puppet:///modules/misc/restart_hbase_master.sh',
#	}

#	exec { "restart_habse_master":
#		command => "/home/vagrant/restart_hbase_master.sh",
#		path    => "/usr/local/bin/:/usr/bin/:/bin/:/usr/sbin/",
#		user => root,
#		require => [File['/home/vagrant/restart_hbase_master.sh'], Class['cdh4pseudo::hbase']]
#	}
#}