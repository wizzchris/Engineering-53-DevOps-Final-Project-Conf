#!/bin/bash
echo mongod1 (ip) >> /etc/hosts
echo mongod2 (ip) >> /etc/hosts
echo mongod3 (ip) >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod
