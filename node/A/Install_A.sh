sudo apt-get -y update
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz -C /usr/share/
cd /usr/share/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/
sudo cp /usr/share/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/bin/ndb_mgm* /usr/local/bin/
cd /usr/local/bin
sudo chmod +x ndb_mgm*
sudo mkdir -p /var/lib/mysql-cluster
cd /var/lib/mysql-cluster

sudo cat > config.ini << EOF
[ndbd default]
NoOfReplicas=2
DataMemory=80M
IndexMemory=18M

[tcp default]
portnumber=2202

[ndb_mgmd]
hostname=192.168.50.128
datadir=/var/lib/mysql-cluster

[ndbd]
hostname=192.168.50.129
datadir=/usr/local/mysql/data

[ndbd]
hostname=192.168.50.130
datadir=/usr/local/mysql/data

[mysqld]
hostname=192.168.50.131

EOF

sudo mkdir -p /usr/local/mysql/mysql-cluster
sudo /usr/local/bin/ndb_mgmd -f /var/lib/mysql-cluster/config.ini 
sudo ndb_mgm -e show
   




#   52  sudo vim config.ini 
#   54  ndb_mgm -e 1 stop
#   75  sudo vim config.ini 
#  102  sudo /usr/local/bin/ndb_mgmd -f  /var/lib/mysql-cluster/config.ini  --initial
#  103  ndb_mgm -e show
#  120  ps -aux | grep mysql
#  121  cat /var/lib/mysql-cluster/config.ini 
#   124  sudo netstat  -antpu

