#!/bin/bash
set -euo pipefail

sudo wget https://packages.microsoft.com/config/rhel/7/mssql-server.repo -O /etc/yum.repos.d/mssql-server.repo
sudo yum install mssql-server -y
sudo /opt/mssql/bin/sqlservr-setup
sudo wget https://packages.microsoft.com/config/rhel/7/prod.repo -O /etc/yum.repos.d/prod.repo
sudo yum install mssql-tools -y
