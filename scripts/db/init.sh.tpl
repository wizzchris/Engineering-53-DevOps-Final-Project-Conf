#!/bin/bash

echo '10.0.10.100' >> /etc/hosts

sudo systemctl enable mongod
sudo systemctl start mongod

mongo mongodb://10.0.10.100 --eval "rs.initiate( { _id : 'rs0', members: [{ _id: 0, host: '10.0.10.100:27017' }]})"
mongo mongodb://10.0.10.100 --eval "rs.add( '10.0.11.100:27017' )"
mongo mongodb://10.0.10.100 --eval "rs.add( '10.0.12.100:27017' )"
mongo mongodb://10.0.10.100 --eval "db.isMaster().primary"
mongo mongodb://10.0.10.100 --eval "rs.slaveOk()"


sleep 60; sudo systemctl restart metricbeat
sudo systemctl restart filebeat

sleep 180; sudo filebeat setup -e \
  -E output.logstash.enabled=false \
  -E output.elasticsearch.hosts=['10.0.13.100:9200'] \
  -E setup.kibana.host=10.0.13.101:5601 && sudo metricbeat setup
