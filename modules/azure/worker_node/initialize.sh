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

mkdir worker_node &&
chmod 755 worker_node &&
chown -R paloalto /worker_node &&
touch /worker_node/monitor.cfg &&
chmod 755 /worker_node/monitor.cfg &&

PARAM_FILE=/worker_node/monitor.cfg
echo "[DEFAULT]" > $PARAM_FILE
echo "AZURE_SUBSCRIPTION_ID="${AZURE_SUBSCRIPTION_ID} >> $PARAM_FILE
echo "AZURE_CLIENT_ID="${AZURE_CLIENT_ID} >> $PARAM_FILE
echo "AZURE_CLIENT_SECRET="${AZURE_CLIENT_SECRET} >> $PARAM_FILE
echo "AZURE_TENANT_ID="${AZURE_TENANT_ID} >> $PARAM_FILE
echo "PANORAMA_IP="${PANORAMA_IP} >> $PARAM_FILE
echo "PANORAMA_API_KEY="${PANORAMA_API_KEY} >> $PARAM_FILE
echo "LICENSE_DEACTIVATION_API_KEY="${LICENSE_DEACTIVATION_API_KEY} >> $PARAM_FILE
echo "RG_NAME="${RG_NAME} >> $PARAM_FILE
echo "WORKER_NAME="${WORKER_NAME} >> $PARAM_FILE
echo "VMSS_NAME="${VMSS_NAME} >> $PARAM_FILE
echo "APPINSIGHTS_NAME="${APPINSIGHTS_NAME} >> $PARAM_FILE
echo "STORAGE_ACCT_NAME="${STORAGE_ACCT_NAME} >> $PARAM_FILE
echo "STORAGE_ACCT_RG="${STORAGE_ACCT_RG} >> $PARAM_FILE
echo "TMPL_STACK="${TMPL_STACK} >> $PARAM_FILE
