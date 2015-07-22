$fuel_settings = parseyaml(file('/etc/astute.yaml'))
class { 'ceph_hammer':
    ceph_hammer_ec_rgw            => $fuel_settings['ceph_hammer']['ceph_hammer_ec_rgw'],
    ceph_hammer_repl_count        => $fuel_settings['ceph_hammer']['ceph_hammer_repl_count'],
}
