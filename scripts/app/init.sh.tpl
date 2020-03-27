#!/bin/bash

sleep 30
cd /home/ubuntu/AppFolder/app

export DB_HOST=mongodb://10.0.10.100:27017,10.0.11.100:27017,10.0.12.100:27017/posts?replicaSet=rs0


sudo npm install
node seeds/seed.js

sudo npm start &

sudo filebeat modules enable nginx
