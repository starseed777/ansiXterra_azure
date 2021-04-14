#!/bin/bash

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo apt-get update && sudo apt-get install -y libssl-dev libffi-dev python-dev python-pip
apt install python3-pip -y 
pip3 install ansible[azure]
ansible-galaxy collection install azure.azcollection
wget https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
pip3 install -r requirements-azure.txt
mkdir /opt/ansible 
mkdir ~/.azure 
touch ~/.azure/credentials
cd /opt/ansible 
touch backend.yml