sudo apt-get update
sudo apt-get install vim
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
sudo cp /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/bin/ndbd  /usr/local/bin/
cd /usr/local/bin
sudo chmod +x ndb*

sudo cat > /etc/my.cnf << EOF
[mysqld]
ndbcluster

[mysql_cluster]
ndb-connectstring=192.168.50.128
EOF

sudo mkdir -p /opt/data/mysql/data
sudo /usr/local/bin/ndbd
