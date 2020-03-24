#!/bin/bash

echo 'mongod1 10.0.10.100' >> /etc/hosts
echo 'mongod2 10.0.11.100' >> /etc/hosts
echo 'mongod3 10.0.12.100' >> /etc/hosts
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
