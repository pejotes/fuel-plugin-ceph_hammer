class ceph_hammer (
$nfs_volume_for_nova,
$nfs_mount_point_nova,
){
  include ceph_hammer::params
  # Install package and start services
  package { $ceph_hammer::params::package_name:
    ensure => present,
  }

  # Configure Nova
  nova_config {
    'DEFAULT/instances_path': value => "${nfs_mount_point_nova}/instances";
  }~> Service["$::nova_nfs::params::service_name"]
  # Create Mount Point
  exec{ "/bin/mkdir -p ${nfs_mount_point_nova}":
    unless => "/usr/bin/test -d ${nfs_mount_point_nova}",
	before => Mount["$nfs_mount_point_nova"],
  }

  # Mount NFS Share 
  mount { "$nfs_mount_point_nova":
     atboot  => true,
     ensure  => mounted,
     device  => "$nfs_volume_for_nova",
     fstype  => "nfs",
     options => "vers=3",
  }
  # Apply permission on mount point
  exec{ "/bin/chown nova:nova $nfs_mount_point_nova":
	require => Mount["$nfs_mount_point_nova"],
  }
  exec{ "/bin/chmod 775 $nfs_mount_point_nova":
	require => Mount["$nfs_mount_point_nova"],
  }
  exec{ "/bin/mkdir -p ${nfs_mount_point_nova}/instances":
	unless => "/usr/bin/test -d ${nfs_mount_point_nova}/instances",
	require => Mount["$nfs_mount_point_nova"],
  }
  exec{ "/bin/chown nova:nova ${nfs_mount_point_nova}/instances":
	require => Exec["/bin/mkdir -p ${nfs_mount_point_nova}/instances"],
  }
  exec{ "/bin/chmod 775 ${nfs_mount_point_nova}/instances":
	require => Exec["/bin/mkdir -p ${nfs_mount_point_nova}/instances"],
	notify => Service["$::nova_nfs::params::service_name"],
  }
}
