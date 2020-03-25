#!/bin/bash
echo 'mongod1 10.0.7.100' >> /etc/hosts
echo 'mongod2 10.0.8.100' >> /etc/hosts
echo 'mongod3 10.0.9.100' >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod

sleep 30; sudo systemctl restart metricbeat
