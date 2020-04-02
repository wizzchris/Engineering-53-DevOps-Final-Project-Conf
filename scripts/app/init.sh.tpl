#!/bin/bash

sleep 200
echo 'export DB_HOST=mongodb://10.0.10.100:27017,10.0.11.100:27017,10.0.12.100:27017/posts?replicaSet=rs0' >> .bashrc

cd /home/ubuntu/AppFolder/app

export DB_HOST=mongodb://10.0.10.100:27017,10.0.11.100:27017,10.0.12.100:27017/posts?replicaSet=rs0

echo $DB_HOST

node seeds/seed.js


sleep 200


sudo npm start &

sudo filebeat modules enable nginx
