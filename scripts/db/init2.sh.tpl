#!/bin/bash
echo 'mongod1 10.0.10.2' >> /etc/hosts
echo 'mongod2 10.0.11.2' >> /etc/hosts
echo 'mongod3 10.0.12.2' >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod
