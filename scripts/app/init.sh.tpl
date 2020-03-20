#!/bin/bash

cd /home/ubuntu/app
echo DB_HOST='mongodb://mongod1:27017,mongodb://mongod2:27017,mongodb://mongod3:27017/posts?replicaSet=r0'
npm install
npm start
