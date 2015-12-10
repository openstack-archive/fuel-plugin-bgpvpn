service { 'neutron-server':
    ensure => running,
}

$inject_script = '/tmp/inject_service_plugins.sh'
file { $inject_script:
    ensure => file,
    content => template('networking-bgpvpn/inject_service_plugins.sh'),
}
$neutron_conf_file='/etc/neutron/neutron.conf'
file { $neutron_conf_file:
    ensure => file
}
exec { 'inject_service_plugins':
    command => "bash $inject_script /etc/neutron/neutron.conf networking_bgpvpn.neutron.services.plugin.BGPVPNPlugin",
    require => File[$inject_script],
    path => '/usr/local/bin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/sbin',
    subscribe => File[$neutron_conf_file],
}

class {'networking-bgpvpn':
    notify => Service['neutron-server']}
class {'networking-bgpvpn-backend-config':
    notify => Service['neutron-server']}
