package {'python-networking-bgpvpn':
    ensure => installed,
} ->
neutron_config { 'DEFAULT/service_plugins': value => 'networking_bgpvpn.neutron.services.plugin.BGPVPNPlugin';}


