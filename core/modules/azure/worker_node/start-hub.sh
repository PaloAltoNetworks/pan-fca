#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update &&
apt-get install -y python-pip &&
pip install azure-cli applicationinsights &&
pip install azure-batch &&
pip install azure-mgmt-storage &&
pip install setuptools && 
pip install azure &&
pip install configparser &&

mkdir /usr/sbin &&
chmod 755 /usr/sbin &&
cp monitor.py /usr/sbin/monitor.py &&
cp monitor.py /usr/sbin/publish.py &&
chmod 755 /usr/sbin/monitor.py  &&
chmod 755 /usr/sbin/publish.py  &&

PARAM_FILE=/usr/sbin/monitor.cfg
echo "[DEFAULT]" > $PARAM_FILE
echo "AZURE_SUBSCRIPTION_ID=$1" >> $PARAM_FILE
echo "AZURE_CLIENT_ID=$2" >> $PARAM_FILE
echo "AZURE_CLIENT_SECRET=$3" >> $PARAM_FILE
echo "AZURE_TENANT_ID=$4" >> $PARAM_FILE
echo "PANORAMA_IP=$5" >> $PARAM_FILE
echo "PANORAMA_API_KEY=$6" >> $PARAM_FILE
echo "LICENSE_DEACTIVATION_API_KEY=$7" >> $PARAM_FILE
echo "RG_NAME=$8" >> $PARAM_FILE
echo "WORKER_NAME=$9" >> $PARAM_FILE
echo "VMSS_NAME=${10}" >> $PARAM_FILE
echo "APPINSIGHTS_NAME=${11}" >> $PARAM_FILE
echo "STORAGE_ACCT_NAME=${12}" >> $PARAM_FILE
echo "STORAGE_ACCT_RG=${13}" >> $PARAM_FILE
echo "TMPL_STACK=${14" >> $PARAM_FILE





sleep 60 &&

crontab -l > _tmp_file
echo "*/5 * * * * /usr/sbin/monitor.py" >> _tmp_file
crontab _tmp_file
