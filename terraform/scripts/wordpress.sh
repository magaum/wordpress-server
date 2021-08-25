#!/bin/bash -x

MYSQL_VERSION=mysql80-community-release-el7-3.noarch.rpm

# Download MySQL server
wget -q -O /tmp/$MYSQL_VERSION https://dev.mysql.com/get/$MYSQL_VERSION

# Resolve and install mysql dependencies
sudo yum localinstall -y /tmp/$MYSQL_VERSION

# Install mysql server
sudo yum install -y mysql-community-server

# Enable service on startup
sudo systemctl enable mysqld

# Start mysql service
sudo systemctl mysqld start

# Wait for service start
sleep 2

# PHP wordpress dependency, must be version 5.20 at least
sudo amazon-linux-extras install php7.2 -y

# Apache server
sudo yum -y install httpd

# Enable httpd service on startup
sudo systemctl enable httpd

# Start httpd service
sudo systemctl start httpd

# Download wordpress
wget -q -O /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz

# Extracting latest.tar.gz on tmp directory
sudo tar -xzf /tmp/latest.tar.gz -C /tmp/

# Move wordpress directory content to apache directory
sudo mv /tmp/wordpress/* /var/www/html/

# Changing permission of wordpress files
sudo chmod -R 755 /var/www/html/*

# Create user
sudo mysql -u ${master_rds_user} -h ${host} -p${master_rds_user_password} << EOF
CREATE USER ${wordpress_user}@'%' IDENTIFIED BY '${wordpress_user_password}';
EOF

# Grant permission to wordpress database
sudo mysql -u ${master_rds_user} -h ${host} -p${master_rds_user_password} << EOF
GRANT ALL PRIVILEGES ON ${wordpress_database}.* TO ${wordpress_user}@'%';
FLUSH PRIVILEGES;
EOF
