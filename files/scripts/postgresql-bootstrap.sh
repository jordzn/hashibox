#!/bin/bash
set -euo pipefail

wget https://ftp.postgresql.org/pub/source/v9.6.2/postgresql-9.6.2.tar.gz
tar -xvf postgresql-9.6.2.tar.gz
sudo yum groupinstall “Development tools”
sudo yum install zlib-devel readline-devel
