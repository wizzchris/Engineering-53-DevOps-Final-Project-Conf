#!/bin/bash

echo mongod1 (ip) >> /etc/hosts
echo mongod2 (ip) >> /etc/hosts
echo mongod3 (ip) >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod
mongo --eval "rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "mongod1:27017" },
      { _id: 1, host: "mongod2:27017" },
      { _id: 2, host: "mongod3:27017" }
   ]
})" mongod1

mongo --eval "rs.status()"
