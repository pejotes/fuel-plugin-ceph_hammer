class ceph_hammer::params {
  $ceph_conf = '/etc/ceph/ceph.conf'

      if $::osfamily == 'Debian' {
            $required_packages      = [ 'ceph', 'ceph-common' ]
                                                $package_name           = 'ceph'
                                                    $service_name           = 'ceph'
                                                        $nfs_service_name = undef

      } elsif($::osfamily == 'RedHat') {
            $required_packages      = [ 'rpcbind', 'nfs-utils', 'nfs-utils-lib',
                                            'libevent', 'libtirpc', 'libgssglue' ]
                                                $package_name           = 'openstack-nova-compute'
                                                    $service_name           = 'openstack-nova-compute'
                                                        $nfs_service_name = ['rpcbind']

      } else {
          fail("unsuported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
      }

}
