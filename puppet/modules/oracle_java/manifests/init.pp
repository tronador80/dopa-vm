class oracle_java(
  $version = $oracle_java::params::default_version,
  $isdefault = $oracle_java::params::isdefault,
  $java_home = "/usr/lib/jvm/java-$version-oracle",
  $java_pkg = "oracle-java7-set-default",
) inherits oracle_java::params {
  exec { 'apt-get-update':
    command => '/usr/bin/apt-get update',
  }

  package { 'python-software-properties':
    ensure  => 'present',
    require => Exec['apt-get-update'], 
  }

  exec { 'add-oracle-repository':
    command => "/usr/bin/apt-add-repository ppa:webupd8team/java",
    require => Package['python-software-properties'],
  }

  exec { 'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections',
      require => Exec['add-oracle-repository'],
  }

  exec { 'set-licence-selected':
    command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
    require => Exec['set-licence-seen'],
  }

  if $isdefault {
    package { "$java_pkg" :
      ensure  => present,
      require => Exec['set-licence-selected'],
    }
   }else{
    $java_pkg = "oracle-java$version-installer"
    package { "$java_pkg" :
      ensure  => present,
      require => Exec['set-licence-selected'],
    }
  }

  if  $java_home != "/usr/lib/jvm/java-$version-oracle" {
    file { "$java_home": 
      ensure  => 'link',
      target  => "/usr/lib/jvm/java-$version-oracle",
      require => Package["$java_pkg"],
    }
  }
}
