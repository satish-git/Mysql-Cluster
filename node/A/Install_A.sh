#!/bin/sh
while read line; do        
echo $line | sudo tee -a  /etc/hosts
done < ../hostname.txt


sudo apt-get -y update
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
sudo cp /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/bin/ndb_mgm* /usr/local/bin/
cd /usr/local/bin
sudo chmod +x ndb_mgm*
sudo mkdir -p /opt/data/mysql/mysql-cluster
cd /opt/data/mysql/mysql-cluster

sudo cat > config.ini << EOF
[ndbd default]
NoOfReplicas=2
DataMemory=80M
IndexMemory=18M

[tcp default]
portnumber=2202

[ndb_mgmd]
hostname=A-node.com
datadir=/opt/data/mysql/mysql-cluster

[ndbd]
hostname=B-node.com
datadir=/opt/data/mysql/data

[ndbd]
hostname=C-node.com
datadir=/opt/data/mysql/data

[mysqld]

[mysqld]

EOF

sudo mkdir -p /opt/data/mysql/mysql-config
# sudo /usr/local/bin/ndb_mgmd -f /opt/data/mysql/mysql-cluster/config.ini --configdir=/opt/data/mysql/mysql-cluster
sudo /usr/local/bin/ndb_mgmd --config-file=/opt/data/mysql/mysql-cluster/config.ini --configdir=/opt/data/mysql/mysql-config
sudo ndb_mgm -e show
   




#   52  sudo vim config.ini 
#   54  ndb_mgm -e 1 stop
#   75  sudo vim config.ini 
#  102  sudo /usr/local/bin/ndb_mgmd -f  /opt/data/mysql/mysql-cluster/config.ini  --initial
#  103  ndb_mgm -e show
#  120  ps -aux | grep mysql
#  121  cat /opt/data/mysql/mysql-cluster/config.ini 
#   124  sudo netstat  -antpu

# sudo /usr/local/bin/ndb_mgmd --config-file=/opt/data/mysql/mysql-cluster/config.ini --configdir=/opt/data/mysql/mysql-config --skip-config-cache
