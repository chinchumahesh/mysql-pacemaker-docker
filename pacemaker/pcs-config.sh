#!/bin/bash

# Wait for MySQL nodes to be ready
sleep 30

# Authenticate nodes
pcs host auth mysql-master mysql-slave1 mysql-slave2 -u hacluster -p hacluster

# Create cluster
pcs cluster setup mysql_cluster mysql-master mysql-slave1 mysql-slave2 --force
pcs cluster start --all
pcs cluster enable --all

# Configure VIPs
pcs resource create rw_vip IPaddr2 ip=192.168.100.100 cidr_netmask=24 op monitor interval=30s
pcs resource create ro_vip IPaddr2 ip=192.168.100.101 cidr_netmask=24 op monitor interval=30s

# Set constraints
pcs constraint colocation add rw_vip with master mysql-master INFINITY
pcs constraint order promote mysql-master then start rw_vip
pcs constraint colocation add ro_vip with slave mysql-slave1 mysql-slave2 INFINITY