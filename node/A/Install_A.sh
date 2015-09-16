sudo apt-get -y update
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
cd /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/
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
hostname=192.168.50.128
datadir=/opt/data/mysql/mysql-cluster

[ndbd]
hostname=192.168.50.129
datadir=/opt/data/mysql/data

[ndbd]
hostname=192.168.50.130
datadir=/opt/data/mysql/data

[mysqld]
hostname=192.168.50.131

EOF

sudo mkdir -p /usr/local/mysql/mysql-cluster
sudo /usr/local/bin/ndb_mgmd -f /opt/data/mysql/mysql-cluster/config.ini --configdir=/opt/data/mysql/mysql-cluster
sudo ndb_mgm -e show
   




#   52  sudo vim config.ini 
#   54  ndb_mgm -e 1 stop
#   75  sudo vim config.ini 
#  102  sudo /usr/local/bin/ndb_mgmd -f  /opt/data/mysql/mysql-cluster/config.ini  --initial
#  103  ndb_mgm -e show
#  120  ps -aux | grep mysql
#  121  cat /opt/data/mysql/mysql-cluster/config.ini 
#   124  sudo netstat  -antpu

