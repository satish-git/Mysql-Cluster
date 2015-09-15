sudo apt-get -y update
sudo apt-get -y  install vim
sudo tar -zxvf mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz 
cd mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/
sudo cp bin/ndb_mgm* /usr/local/bin/
cd /usr/local/bin
sudo chmod +x ndb_mgm*
sudo mkdir /var/lib/mysql-cluster
cd /var/lib/mysql-cluster
sudo cat  config.ini << EOF

[ndbd default]
# Options affecting ndbd processes on all data nodes:
NoOfReplicas=2
DataMemory=80M
IndexMemory=18M

[tcp default]
# TCP/IP options:
portnumber=2202

[ndb_mgmd]
# Management process options:
hostname=192.168.50.128
datadir=/var/lib/mysql-cluster

[ndbd]
# Options for data node "A":
hostname=192.168.50.129
datadir=/usr/local/mysql/data

[ndbd]
# Options for data node "B":
hostname=192.168.50.130
datadir=/usr/local/mysql/data

[mysqld]
# SQL node options:
hostname=192.168.50.131
[mysqld]
hostname=192.168.50.132

EOF






sudo mkdir -p /usr/local/mysql/mysql-cluster
sudo /usr/local/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini 
ndb_mgm -e show
   




   52  sudo vim config.ini 
   54  ndb_mgm -e 1 stop
   75  sudo vim config.ini 
  102  sudo /usr/local/bin/ndb_mgmd -f  /var/lib/mysql-cluster/config.ini  --initial
  103  ndb_mgm -e show
  120  ps -aux | grep mysql
  121  cat /var/lib/mysql-cluster/config.ini 
  124  sudo netstat  -antpu
