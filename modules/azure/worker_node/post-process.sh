#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

cp /worker_node/monitor.py /worker_node/publish.py &&
chmod 755 /worker_node/monitor.py  &&
chmod 755 /worker_node/publish.py  &&

sleep 15 &&

crontab -l > _tmp_file
echo "*/5 * * * * /worker_node/monitor.py" >> _tmp_file
crontab _tmp_file