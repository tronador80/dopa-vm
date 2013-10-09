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
class role::stratodev{
	include role::generic
	class { 'git': }
	$ozoneDir = '/dopa-vm/stratosphere-dev'
	$meteorDir = '/dopa-vm/meteor-dev'

	@git::clone { 'TU-Berlin/ozone':
	directory => $ozoneDir,
	}

	@git::clone { 'TU-Berlin/ozone-meteor':
	directory => $meteorDir,
	}

}
# == Class: role::stratotester
# Provisions a Stratosphere instance powered by Oracle Java.
class role::stratotester {
	include role::generic
    class { 'stratodist': }

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