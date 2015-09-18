#!/bin/sh
while read line; do
echo $line | sudo tee -a  /etc/hosts
done < ../hostname.txt

sudo apt-get update
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
sudo cp /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/bin/ndbd  /usr/local/bin/
cd /usr/local/bin
sudo chmod +x ndb*

sudo cat > /etc/my.cnf << EOF
[mysqld]
ndbcluster

[mysql_cluster]
ndb-connectstring=A-node.com
EOF

sudo mkdir -p /opt/data/mysql/data
sudo /usr/local/bin/ndbd
