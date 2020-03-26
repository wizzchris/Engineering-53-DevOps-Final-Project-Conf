#!/bin/bash

echo '127.0.0.1 localhost mongod3' > /etc/hosts

echo '10.0.7.100 mongod1' >> /etc/hosts
echo '10.0.8.100 mongod2' >> /etc/hosts
echo '10.0.9.100 mongod3' >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod


sleep 60; sudo systemctl restart metricbeat
