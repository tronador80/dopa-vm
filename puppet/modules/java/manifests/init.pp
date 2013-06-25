class java( $version = '7u25-0~webupd8~0', $dbname = undef ) {

	exec{ 'add-ppa-repo':
	command => 'add-apt-repository ppa:webupd8team/java -y',
	user => root,
	notify => Exec["update-packages"],
	}

	exec { 'update-packages':
	# run 'apt-get update', but no more than once every 24h
	command => 'apt-get update'
	}
	 exec {
    'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';
 
    'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
  }
 
  package { 'oracle-java7-installer':
    ensure => "${version}",
    require => [Exec['add-ppa-repo'], Exec['set-licence-selected'], Exec['set-licence-seen']],
  }


}
#Inspired from http://www.markhneedham.com/blog/2013/04/18/puppet-installing-oracle-java-oracle-license-v1-1-license-could-not-be-presented/