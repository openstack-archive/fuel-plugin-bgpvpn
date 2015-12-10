class networking-bgpvpn {
    require => Class['neutron']
    package {'python-networking-bgpvpn':
        ensure => installed,
        notify => Service['neutron-server']
    }
    package {'networking-bgpvpn-config':
        ensure => installed,
        notify => Service['neutron-server']
    }
    $service_plugins = $neutron_config['DEFAULT']['service_plugins']
    $service_plugins += 'networking_bgpvpn.neutron.services.plugin.BGPVPNPlugin'
    neutron_config { 'DEFAULT/service_plugins': value => join($service_plugins, ',');}
    if defined( "opendaylight" ){
        $NETWORKING_BGPVPN_DRIVER = 'BGPVPN:OpenDaylight:networking_bgpvpn.neutron.services.service_drivers.opendaylight.odl.OpenDaylightBgpvpnDriver:default'
    }
    else {
        fail('Bagpipe driver not yet included. You need to have anotehr bgpvpn dirver: Opendaylight')
    }
    # In liberty this goes to an own config file
    neutron_config { 'service_providers/service_provider' $NETWORKING_BGPVPN_DRIVER;}

    # This is only needed for kilo.
    # fuel-library/puppet/neutron/manifest/server.pp: exec 'neutron-db-sync' was taken as
    # example. In liberty it is not needed
    exec { 'bgpvpn-db-sync':
      command     => 'bgpvpn-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head',
      path        => '/usr/local/bin:/usr/bin:/sbin:/bin:/usr/local/sbin:/usr/sbin',
      before      => Service['neutron-server'],
      subscribe   => Neutron_config['database/connection'],
      refreshonly => true,
      tries       => 10,
      # TODO(bogdando) contribute change to upstream:
      #   new try_sleep param for sleep driven development (SDD)
      try_sleep   => 20,
    }
    exec<| title == 'neutron-db-sync'|> ~> Exec['bgpvpn-db-sync']
}