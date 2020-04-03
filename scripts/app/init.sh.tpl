#!/bin/bash

sleep 120

cd /home/ubuntu/AppFolder/app

export DB_HOST=mongodb://10.0.10.100:27017/posts,10.0.11.100:27017/posts,10.0.12.100:27017/posts?replicaSet=rs0


node seeds/seed.js

node app.js &

sudo filebeat modules enable nginx
