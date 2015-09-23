#!/bin/sh
while read line; do        
echo $line | sudo tee -a  /etc/hosts
done < ../hostname.txt


sudo apt-get -y update
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
sudo cp /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/bin/ndb_mgm* /usr/local/bin/

# Add User & Group
sudo groupadd mysql
sudo useradd -r -g mysql mysql

cd /usr/local/bin
sudo chmod +x ndb_mgm*
sudo mkdir -p /opt/data/mysql/mysql-cluster
sudo mkdir -p /opt/data/mysql/mysql-config
sudo chown -R mysql.mysql /opt/data/mysql
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

sudo apt-get install -y supervisor
sudo mkdir -p /var/log/loonyard
sudo cat > /etc/supervisor/conf.d/mysql.conf << EOF
[program:mysql]
command=ndb_mgmd --config-file=/opt/data/mysql/mysql-cluster/config.ini --configdir=/opt/data/mysql/mysql-config
autostart=true
autorestart=true
startretries=3
priority=1
user=mysql
stopasgroup=true
stopsignal=QUIT
stopwaitsecs=10
redirect_stderr=true
stdout_logfile=/var/log/loonyard/mysql.out.log
stdout_logfile_maxbytes=1MB
stdout_logfile_backups=10
stderr_logfile=/var/log/loonyard/mysql.err.log
stderr_logfile_maxbytes=1MB
stderr_logfile_backups=10
EOF

sudo supervisorctl reread
sudo supervisorctl update

# sudo /usr/local/bin/ndb_mgmd -f /opt/data/mysql/mysql-cluster/config.ini --configdir=/opt/data/mysql/mysql-cluster
# sudo /usr/local/bin/ndb_mgmd --config-file=/opt/data/mysql/mysql-cluster/config.ini --configdir=/opt/data/mysql/mysql-config
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
