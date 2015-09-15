#ifconfig 
sudo apt-get update
sudo apt-get install vim
scp ubuntu@192.168.50.128:~/*.tar.gz .
sudo tar -zxvf mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz 
cd mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/
sudo cp bin/ndbd /usr/local/bin/
cd /usr/local/bin
sudo chmod +x ndb*
# sudo vim /etc/my.cnf
sudo cat > /etc/my.cnf << EOF
[mysqld]
ndbcluster

[mysql_cluster]
ndb-connectstring=192.168.50.128
EOF

sudo mkdir -p /usr/local/mysql/data
sudo /usr/local/bin/ndbd
