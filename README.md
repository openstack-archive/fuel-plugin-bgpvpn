BGPVPN Plugin for Fuel
================================

BGPVPN plugin
-----------------------

Overview
--------

BGPVPN fuel plugin.

Requirements
------------

| Requirement                      | Version/Comment |
|----------------------------------|-----------------|
| Mirantis OpenStack compatibility | 7.0             |

Recommendations
---------------

None.

Limitations
-----------

Installation Guide
==================

OpenDaylight plugin installation
----------------------------------------

1. Clone the fuel-plugin-bgpvpn repo from github:

        git clone https://github.com/openstack/fuel-plugin-bgpvpn

2. Install the Fuel Plugin Builder:

        pip install fuel-plugin-builder

3. Install the [fpm gem](https://github.com/jordansissel/fpm):

        gem install fpm
    
4. Build bgpvpn Fuel plugin:

        fpb --build fuel-plugin-bgpvpn/

5. The *bgpvpn-[x.x.x].rpm* plugin package will be created in the plugin folder.
  
6. Move this file to the Fuel Master node with secure copy (scp):

        scp bgpnvpn-[x.x.x].rpm root@<the_Fuel_Master_node_IP address>:/tmp

7. While logged in Fuel Master install the OpenDaylight plugin:

        fuel plugins --install bgpvpn-[x.x.x].rpm

8. Check if the plugin was installed successfully:

        fuel plugins

        id | name         | version | package_version
        ---|--------------|---------|----------------
        1  | bgpvpn       | 0.1.0   | 3.0.0

9. Plugin is ready to use and can be enabled on the Settings tab of the Fuel web UI.


User Guide
==========

Contributors
------------

