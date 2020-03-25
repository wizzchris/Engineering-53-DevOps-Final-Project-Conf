#!/bin/bash

cd /home/ubuntu/AppFolder/app
cd /home/ubuntu/app

sudo npm install
sudo npm start


echo DB_HOST='mongodb://mongod1:27017,mongodb://mongod2:27017,mongodb://mongod3:27017/posts?replicaSet=r0'

sleep 120; sudo metricbeat setup && sudo filebeat setup
