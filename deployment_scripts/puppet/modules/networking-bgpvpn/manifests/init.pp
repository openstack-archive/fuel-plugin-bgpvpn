class networking-bgpvpn {

    package {'python-networking-bgpvpn':
        ensure => installed,
        notify => Service['neutron-server'],
    }
    package {'networking-bgpvpn-config':
        ensure => installed,
        notify => Service['neutron-server'],
    }
    # fuel-library/puppet/neutron/manifest/server.pp: exec 'neutron-db-sync' was taken as
    # example. In liberty it is not needed
    exec { 'bgpvpn-db-sync':
      command     => 'neutron-db-manage --config-file /etc/neutron/neutron.conf --subproject networking-bgpvpn upgrade head',
      path        => '/usr/local/bin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/sbin',
      notify      => Service['neutron-server'],
      # TODO
      #subscribe   => Neutron_config['database/connection'],
      tries       => 10,
      # TODO(bogdando) contribute change to upstream:
      #   new try_sleep param for sleep driven development (SDD)
      try_sleep   => 20,
      require => Package["python-networking-bgpvpn"]
    }
    Exec<| title == 'neutron-db-sync' |> ~> Exec['bgpvpn-db-sync']
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
