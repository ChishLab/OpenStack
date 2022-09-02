#--------------------system Config--------------------##
#Controller Server Manager IP. example:x.x.x.x
HOST_IP=192.168.100.10

#Controller HOST Password. example:000000 
HOST_PASS=000000

#Controller Server hostname. example:controller
HOST_NAME=controller

#Compute Node Manager IP. example:x.x.x.x
HOST_IP_NODE=192.168.100.20

#Compute HOST Password. example:000000 
HOST_PASS_NODE=000000

#Compute Node hostname. example:compute
HOST_NAME_NODE=compute

#--------------------Chrony Config-------------------##
#Controller network segment IP.  example:x.x.0.0/16(x.x.x.0/24)
network_segment_IP=192.168.100.0/24

#--------------------Rabbit Config ------------------##
#user for rabbit. example:openstack
RABBIT_USER=openstack

#Password for rabbit user .example:000000
RABBIT_PASS=000000

#--------------------MySQL Config---------------------##
#Password for MySQL root user . exmaple:000000
DB_PASS=000000

#--------------------Keystone Config------------------##
#Password for Keystore admin user. exmaple:000000
DOMAIN_NAME=demo
ADMIN_PASS=000000
DEMO_PASS=000000

#Password for Mysql keystore user. exmaple:000000
KEYSTONE_DBPASS=000000

#--------------------Glance Config--------------------##
#Password for Mysql glance user. exmaple:000000
GLANCE_DBPASS=000000

#Password for Keystore glance user. exmaple:000000
GLANCE_PASS=000000

#--------------------Nova Config----------------------##
#Password for Mysql nova user. exmaple:000000
NOVA_DBPASS=000000

#Password for Keystore nova user. exmaple:000000
NOVA_PASS=000000

#--------------------Neturon Config-------------------##
#Password for Mysql neutron user. exmaple:000000
NEUTRON_DBPASS=000000

#Password for Keystore neutron user. exmaple:000000
NEUTRON_PASS=000000

#metadata secret for neutron. exmaple:000000
METADATA_SECRET=000000

#Tunnel Network Interface. example:x.x.x.x
INTERFACE_IP=192.168.100.10/192.168.100.20

#External Network Interface. example:eth1
INTERFACE_NAME=ens33

#External Network The Physical Adapter. example:provider
Physical_NAME=provider

#First Vlan ID in VLAN RANGE for VLAN Network. exmaple:101
minvlan=101

#Last Vlan ID in VLAN RANGE for VLAN Network. example:200
maxvlan=200

#--------------------Cinder Config--------------------##
#Password for Mysql cinder user. exmaple:000000
CINDER_DBPASS=000000

#Password for Keystore cinder user. exmaple:000000
CINDER_PASS=000000

#Cinder Block Disk. example:md126p3
BLOCK_DISK=

#--------------------Swift Config---------------------##
#Password for Keystore swift user. exmaple:000000
SWIFT_PASS=000000

#The NODE Object Disk for Swift. example:md126p4.
OBJECT_DISK=

#The NODE IP for Swift Storage Network. example:x.x.x.x.
STORAGE_LOCAL_NET_IP=192.168.100.20

#--------------------Heat Config----------------------##
#Password for Mysql heat user. exmaple:000000
HEAT_DBPASS=000000

#Password for Keystore heat user. exmaple:000000
HEAT_PASS=000000

#--------------------Zun Config-----------------------##
#Password for Mysql Zun user. exmaple:000000
ZUN_DBPASS=000000

#Password for Keystore Zun user. exmaple:000000
ZUN_PASS=000000

#Password for Mysql Kuryr user. exmaple:000000
KURYR_DBPASS=000000

#Password for Keystore Kuryr user. exmaple:000000
KURYR_PASS=000000

#--------------------Ceilometer Config----------------##
#Password for Gnocchi ceilometer user. exmaple:000000
CEILOMETER_DBPASS=000000

#Password for Keystore ceilometer user. exmaple:000000
CEILOMETER_PASS=000000

#--------------------AODH Config----------------##
#Password for Mysql AODH user. exmaple:000000
AODH_DBPASS=000000

#Password for Keystore AODH user. exmaple:000000
AODH_PASS=000000

#--------------------Barbican Config----------------##
#Password for Mysql Barbican user. exmaple:000000
BARBICAN_DBPASS=000000

#Password for Keystore Barbican user. exmaple:000000
BARBICAN_PASS=000000