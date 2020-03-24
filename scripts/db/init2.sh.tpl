#!/bin/bash
echo 'mongod1 172.16.10.104' >> /etc/hosts
echo 'mongod2 172.16.10.105' >> /etc/hosts
echo 'mongod3 172.16.10.106' >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod
