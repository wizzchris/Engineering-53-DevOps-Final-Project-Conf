#!/bin/bash
echo '127.0.0.1 localhost mongod1' > /etc/hosts
echo '10.0.7.100 mongod1' >> /etc/hosts
echo '10.0.8.100 mongod2' >> /etc/hosts
echo '10.0.9.100 mongod3' >> /etc/hosts
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

sleep 30; sudo systemctl restart metricbeat
