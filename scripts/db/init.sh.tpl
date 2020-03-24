#!/bin/bash

echo 'mongod1 172.16.10.104' >> /etc/hosts
echo 'mongod2 172.16.10.105' >> /etc/hosts
echo 'mongod3 172.16.10.106' >> /etc/hosts
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
