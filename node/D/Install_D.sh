sudo apt-get update
sudo groupadd mysql
sudo useradd -g mysql mysql
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz  -C /usr/local/
sudo ln -s /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64 /usr/local/mysql
cd /usr/local/mysql
sudo apt-get install -y libaio1

sudo /usr/local/mysql/scripts/mysql_install_db --user=mysql \
	--datadir=/usr/local/mysql/data \
	--basedir=/usr/local/mysql \
	--plugin-dir=/usr/local/mysql/lib/plugin \
	--log-error=/usr/local/mysql/data/ubuntu.err \
	--pid-file=/usr/local/mysql/data/ubuntu.pid

sudo chown -R root .
sudo chown -R mysql data
sudo chown -R mysql .

sudo cat > my.cnf << EOF
[mysqld]
ndbcluster
bind-address = 0.0.0.0

[mysql_cluster]
ndb-connectstring=192.168.50.128
EOF

sudo ln -s /usr/local/mysql/bin/* /usr/local/bin/
sudo ln -s /usr/local/mysql  /usr/share/mysql

sudo cp support-files/mysql.server /etc/init.d/
sudo chmod +x /etc/init.d/mysql.server 

#sudo /etc/init.d/mysql.server start
#sleep 10

# sudo echo -e "\n\nroot\nroot\n\n\ny\n\n " | mysql_secure_installation 2>/dev/null
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root';
# mysql -uroot -p

