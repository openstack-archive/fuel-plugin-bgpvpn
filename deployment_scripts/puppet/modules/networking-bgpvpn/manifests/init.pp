class networking-bgpvpn {

    package {'python-networking-bgpvpn':
        ensure => installed,
        notify => Service['neutron-server'],
    }
    package {'networking-bgpvpn-config':
        ensure => installed,
        notify => Service['neutron-server'],
    }
}

class networking-bgpvpn-backend-config {

    require networking-bgpvpn
    if hiera('opendaylight', false) {
        $NETWORKING_BGPVPN_DRIVER = 'BGPVPN:OpenDaylight:networking_bgpvpn.neutron.services.service_drivers.opendaylight.odl.OpenDaylightBgpvpnDriver:default'
        package {'python-networking-odl':
            ensure => installed,
        }
    }
    else {
        fail('Bagpipe driver not yet included. You need to have anotehr bgpvpn dirver: Opendaylight')
    }
    # In liberty this goes to an own config file
    file { "/etc/neutron/networking_bgpvpn.conf":
      ensure  => file,
      content => template('networking-bgpvpn/networking_bgpvpn.conf'),
    }
}
