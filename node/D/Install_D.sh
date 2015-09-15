# ifconfig 
sudo apt-get update
sudo apt-get install vim
sudo groupadd mysql
sudo useradd -g mysql mysql
sudo tar -zxvf mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz  -C /usr/local/
sudo ln -s /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64 /usr/local/mysql
cd /usr/local/mysql
sudo apt-get install -y  libaio1
sudo scripts/mysql_install_db --user=mysql
sudo chown -R root .
sudo chown -R mysql data
sudo chown -R mysql .
sudo cp support-files/mysql.server /etc/init.d/
sudo chmod +x /etc/init.d/mysql.server 
sudo cat > my.cnf << EOF
[mysqld]
ndbcluster

[mysql_cluster]
ndb-connectstring=192.168.50.128
EOF

sudo /etc/init.d/mysql.server start
# mysql -uroot -p
