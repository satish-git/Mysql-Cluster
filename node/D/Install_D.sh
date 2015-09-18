#!/bin/bash
#!/bin/sh
while read line; do
echo $line | sudo tee -a  /etc/hosts
done < ../hostname.txt

CURRENT_DIR=`pwd`
# Disabling AppArmor
sudo /etc/init.d/apparmor stop
sudo update-rc.d -f apparmor remove
sudo apt-get remove -y apparmor apparmor-utils

# Add User & Group
sudo groupadd mysql
sudo useradd -r -g mysql mysql
#sudo usermod -a -G loonyard mysql

# Install libaio1 package
sudo apt-get install -y libaio1

# Download Tar file & Extrac it in /usr/local/ folder 
sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz  -C /usr/local/

# Create Soft Link
sudo ln -s /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64 /usr/local/mysql

# Give Permission and move data folder in /opt/data/mysql/ directory
#                      sudo mkdir -p /usr/local/mysql/mysqld
#                      
sudo chown -R mysql.mysql /usr/local/mysql/
sudo mkdir -p /opt/data/mysql/
sudo mv /usr/local/mysql/data  /opt/data/mysql/
sudo chown -R mysql.mysql /opt/data/mysql/data
sudo mkdir -p /usr/local/mysql/data
sudo mkdir -p /var/log/loonyard/
#                       sudo mkdir -p /etc/mysql/conf.d/
sudo touch /var/log/loonyard/mysql_error.log
sudo chown mysql.root /var/log/loonyard/mysql_error.log
sudo chmod 664 /var/log/loonyard/mysql_error.log

# Create the following symlink for executing commands
sudo ln -s /usr/local/mysql/bin/* /usr/local/bin/
sudo ln -s /usr/local/mysql  /usr/share/mysql

# Create the necessary & default databases with location
sudo /usr/local/mysql/scripts/mysql_install_db --user=mysql \
     --basedir=/usr/local/mysql \
     --datadir=/opt/data/mysql/data \
     --plugin-dir=/usr/local/mysql/lib/plugin \
     --log-error=/var/log/loonyard/mysql_error.log \
     --pid-file=/usr/local/mysql/data/ubuntu.pid

#Backup my.cnf file
sudo cp   /usr/local/mysql/my.cnf  /usr/local/mysql/my.cnf.orig
# copy my.cnf file
sudo cp $CURRENT_DIR/my.cnf /usr/local/mysql/my.cnf

# Change ownerships
sudo chown -R mysql.root /usr/local/mysql/
sudo chown -R mysql.root /opt/data/mysql/data


# # Copy Mysql service file in init directory (start stop script).
sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql

# Install Supervisior 
sudo apt-get install -y supervisor

# Copy Mysql start-up script under supervisord service
sudo cp $CURRENT_DIR/mysql.conf /etc/supervisor/conf.d/

# Start Mysql service
sudo supervisorctl reread
sudo supervisorctl update
sync
sleep 5

# set a MySQL root password and flash default databases.
# sudo mysql_secure_installation

# Mysql_secure_installation NON-INTERACTIVE Mode
#sudo echo -e "\n\nroot\nroot\n\n\ny\n\n " | mysql_secure_installation 2>/dev/null

#--------------------------Mysql Install---------------------------


















#sudo apt-get update
#sudo groupadd mysql
#sudo useradd -g mysql mysql
#sudo tar -zxvf ../Package/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64.tar.gz  -C /usr/local/
#sudo ln -s /usr/local/mysql-cluster-gpl-7.4.7-linux-glibc2.5-x86_64 /usr/local/mysql
#sudo apt-get install -y  libaio1

#sudo mkdir -p /opt/data/mysql/data

#cd /usr/local/mysql

#sudo /usr/local/mysql/scripts/mysql_install_db --user=mysql \
#	--datadir=/opt/data/mysql/data \
#	--basedir=/usr/local/mysql \
#	--plugin-dir=/usr/local/mysql/lib/plugin \
#	--log-error=/usr/local/mysql/data/ubuntu.err \
#	--pid-file=/usr/local/mysql/data/ubuntu.pid

#sudo chown -R root .
#sudo chown -R mysql data
#sudo chown -R mysql .

#sudo chown -R mysql /opt/data/mysql

#sudo cat > my.cnf << EOF
#[client]
#port=3306
#socket=/tmp/mysql.sock

#[mysqld]
#ndbcluster
#bind-address = 0.0.0.0
#datadir=/opt/data/mysql/data

#[mysql_cluster]
#ndb-connectstring=192.168.50.128
#
#EOF

#sudo ln -s /usr/local/mysql/bin/* /usr/local/bin/
#sudo ln -s /usr/local/mysql  /usr/share/mysql

#sudo cp support-files/mysql.server /etc/init.d/
#sudo chmod +x /etc/init.d/mysql.server 
	
#sudo /etc/init.d/mysql.server start
#sleep 10


# sudo echo -e "\n\nroot\nroot\n\n\ny\n\n " | mysql_secure_installation 2>/dev/null
# GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root';
# mysql -uroot -p

