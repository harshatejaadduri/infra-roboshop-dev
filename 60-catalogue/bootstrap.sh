#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/harshatejaadduri/ansible-roles-terra.git -e component=$1 -e env=$2 main.yaml