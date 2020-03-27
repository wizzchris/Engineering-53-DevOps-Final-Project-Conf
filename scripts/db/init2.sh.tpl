#!/bin/bash

sleep 60; sudo systemctl restart metricbeat
sudo systemctl restart filebeat
