# == Class cdh4::hbase::master
# Installs HBase master
#
class cdh4::hbase::master {

  Class['cdh4::hbase'] -> Class['cdh4::hbase::master']

  package { 'hbase-master': 
    ensure => 'installed',
  }

  service { 'hbase-master':
    ensure      => 'running',
    enable      => true,
    hasrestart  => true,
    require     => File["${::cdh4::hbase::config_directory}/hbase-site.xml"],
    subscribe   => File["${::cdh4::hbase::config_directory}/hbase-site.xml"],
  }

  # sudo -u hdfs hadoop fs -mkdir /hbase
  # sudo -u hdfs hadoop fs -chown hbase /hbase
  cdh4::hadoop::directory { "${::cdh4::hbase::root_dir}":
    owner   => 'hbase',
    group   => 'hbase',
  }

}
