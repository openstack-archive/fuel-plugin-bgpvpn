file { '/usr/share/openstack-dashboard/openstack_dashboard/local/enabled/_1495_project_bgpvpn_panel.py':
    ensure => 'link',
    target => '/usr/local/lib/python2.7/dist-packages/bgpvpn_dashboard/enabled/_1495_project_bgpvpn_panel.py',
}


file { '/usr/share/openstack-dashboard/openstack_dashboard/local/enabled/_2115_admin_bgpvpn_panel.py':
    ensure => 'link',
    target => '/usr/local/lib/python2.7/dist-packages/bgpvpn_dashboard/enabled/_2115_admin_bgpvpn_panel.py',
}

File <||>
~>
service { 'apache2':
    ensure => running,
}
