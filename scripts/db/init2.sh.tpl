#!/bin/bash
echo 'mongod1 10.0.10.100' >> /etc/hosts
echo 'mongod2 10.0.11.100' >> /etc/hosts
echo 'mongod3 10.0.12.100' >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod
