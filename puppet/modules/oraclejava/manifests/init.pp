class oraclejava(
  $version   = "$oraclejava::params::version",
  $isdefault   = "$oraclejava::params::isdefault",
  $javahome  = "/usr/lib/jvm/java-${oraclejava::params::version}",
) inherits oraclejava::params {
  #exec { 'apt-get-update':
  #  command => '/usr/bin/apt-get update',
  #}

  package { 'python-software-properties':
    ensure  => 'present',
    #require => Exec['apt-get-update'], 
  }

  exec { 'add-oracle-repository':
    command => "/usr/bin/apt-add-repository ppa:webupd8team/java; apt-get update",
    require => Package['python-software-properties'],
    unless  => '/usr/bin/test -e /etc/apt/sources.list.d/webupd8team-java-precise.list'
  }

  exec { 
   'set-licence-selected':
     command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections',
     unless => '/usr/bin/test -e /usr/bin/debconf-set-selections';
 
   'set-licence-seen':
     command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections',
     unless => '/usr/bin/test -e /usr/bin/debconf-set-selections';
  }

  if $isdefault {
    $package  = "oracle-java${version}-set-default"
  }else{
    $package = "oracle-java${version}-installer"
  }

  package { "${package}" :
    ensure  => present,
    require => [ Exec['add-oracle-repository'], Exec['set-licence-selected'],  Exec['set-licence-seen'] ]
  }

  if $javahome != "/usr/lib/jvm/java-${version}-oracle" {
    file { "${javahome}": 
      ensure  => 'link',
      target  => "/usr/lib/jvm/java-${version}-oracle",
      require => Package["$package"],
    }
  }
}
