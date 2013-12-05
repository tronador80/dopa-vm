class my::hadoop {
    class { 'cdh4::hadoop':
        # Must pass an array of hosts here, even if you are
        # not using HA and only have a single NameNode.
        namenode_hosts     => ['localhost'],
        datanode_mounts    => ['/var/lib/hadoop/data'],
        # You can also provide an array of dfs_name_dirs.
        dfs_name_dir       => '/var/lib/hadoop',
    }
}

class my::hadoop::master inherits my::hadoop {
    include cdh4::hadoop::master
    include cdh4::hadoop::worker
}

class my::hadoop::worker inherits my::hadoop {
    include cdh4::hadoop::worker
}
