#!/bin/bash

cd /home/ubuntu/AppFolder/app

export DB_HOST='mongodb://mongod1:27017,mongodb://mongod2:27017,mongodb://mongod3:27017/posts?replicaSet=r0'

sudo npm install
sudo npm start

echo DB_HOST='mongodb://mongod1:27017,mongodb://mongod2:27017,mongodb://mongod3:27017/posts?replicaSet=r0'

sudo filebeat modules enable nginx
