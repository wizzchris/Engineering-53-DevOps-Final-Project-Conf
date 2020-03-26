#!/bin/bash

echo '127.0.0.1 localhost mongod1' > /etc/hosts

echo '10.0.7.100 mongod1' >> /etc/hosts
echo '10.0.8.100 mongod2' >> /etc/hosts
echo '10.0.9.100 mongod3' >> /etc/hosts
sudo systemctl enable mongod
sudo systemctl start mongod

sleep 60; sudo systemctl restart metricbeat

sleep 120; sudo filebeat setup -e \  -E output.logstash.enabled=false \
  -E output.elasticsearch.hosts=['10.0.13.100:9200'] \
  -E setup.kibana.host=10.0.13.101:5601 && sudo metricbeat setup

mongo mongod1 --eval "rs.initiate( { _id : "rs0", members: [{ _id: 0, host: "mongod1:27017" }, { _id: 1, host: "mongod2:27017" }, { _id: 2, host: "mongod3:27017" }]})"

mongo mongod1 --eval "rs.status()"
