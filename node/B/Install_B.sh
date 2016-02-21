#!/bin/sh
while read line; do
echo $line | sudo tee -a  /etc/hosts
done < ../hostname.txt

sudo apt-get update
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz -C /usr/local/
sudo cp /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64/bin/ndbd  /usr/local/bin/

# Add User & Group
sudo groupadd mysql
sudo useradd -r -g mysql mysql

cd /usr/local/bin
sudo chmod +x ndb*

sudo cat > /etc/my.cnf << EOF
[mysqld]
ndbcluster
user=mysql
ndb-connectstring=A-node.com

[mysql_cluster]
ndb-connectstring=A-node.com
EOF

sudo mkdir -p /opt/data/mysql/data
sudo chown -R mysql /opt/data/mysql

sudo apt-get install -y supervisor

sudo cat > /etc/supervisor/conf.d/mysql.conf << EOF
[program:mysql]
command=ndbd
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

sudo mkdir -p /var/log/loonyard/
sudo supervisorctl reread
sudo supervisorctl update

