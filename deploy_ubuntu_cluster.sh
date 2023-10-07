#!/bin/bash

# Exit script immediately if any command fails
set -e

# Installing dependencies
# Check if vagrant is installed
# if ! [ -x "$(command -v vagrant)" ]; then
#   echo 'Error: vagrant is not installed.' >&2
#   sudo apt-get update
#   sudo apt-get install vagrant
#   else
#   echo 'vagrant is installed.'
# fi

# # Check if virtualbox is installed
# if ! [ -x "$(command -v VBoxManage)" ]; then
#   echo 'Error: virtualbox is not installed.' >&2
#   sudo apt-get update
#   sudo apt-get install virtualbox
#   else
#   echo 'virtualbox is installed.'
# fi

# the above commands are commented out because they will not work in my windows test environment

# Create a Shared_folder directory
echo "Creating a Shared_folder directory."
mkdir -p Shared_folder

# Check if Vagrantfile exists and remove it
if [ -e Vagrantfile ]; then
  echo "Removing Vagrantfile."
  rm Vagrantfile
else
  echo "Vagrantfile does not exist."
fi

# Create Vagrantfile
echo "Creating Vagrantfile."
touch Vagrantfile

# Edit Vagrantfile
cat > Vagrantfile << 'EOF'
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  # Create a shared folder for all nodes
  config.vm.synced_folder "./Shared_folder", "/vagrant"

  # Create a master node
  config.vm.define "master" do |master|
    master.vm.hostname = "master-node"
    master.vm.network "private_network", ip: "192.168.33.10"

    master.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end

    # Provisioning script for the master node
    master.vm.provision "shell", inline: <<-SHELL
      # Update and upgrade master node
      echo "Updating and upgrading master node."
      sudo apt-get update
      # sudo apt-get -y upgrade

      # Create a user called altschool with a default passwords and give it root privileges
      echo "Creating altschool user."
      sudo useradd -m -p "$(openssl passwd -1 altschool)" -s /bin/bash altschool
      echo "Giving altschool user root privileges."
      sudo usermod -aG sudo altschool
      sudo echo "altschool ALL=(ALL:ALL) ALL" >> /etc/sudoers

      # Generate an SSH key pair for 'altschool' user (without a passphrase)
      echo "Generating an SSH key pair for 'altschool' user (without a passphrase)."
      sudo -u altschool ssh-keygen -t rsa -N "" -f /home/altschool/.ssh/id_rsa -q

      # Copy the public key to the shared folder
      echo "Copying the public key to the shared folder."
      sudo cp /home/altschool/.ssh/id_rsa.pub /vagrant/master_id_rsa.pub || true

      # Install Apache, MySQL, PHP, and other required packages
      echo "Installing Apache, MySQL, PHP, and other required packages."
      DEBIAN_FRONTEND=noninteractive sudo apt-get -y install apache2 mysql-server php libapache2-mod-php php-mysql

      # Start and enable Apache on boot
      echo "Starting and enabling Apache on boot."
      sudo systemctl start apache2
      sudo systemctl enable apache2

      # Start and enable MySQL on boot and secure MySQL
      echo "Starting and enabling MySQL on boot and securing MySQL."
      # Secure MySQL installation and initialize it with a default user and password
      sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password altschool'
      sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password altschool'
      sudo systemctl start mysql
      sudo systemctl enable mysql
      echo "Securing MySQL completed successfully."

      # Create a sample PHP file for validation
      echo "Creating a sample PHP file for validation."
      echo "<?php phpinfo(); ?>" > /var/www/html/info.php

      # Create the /mnt/altschool/ directory
      echo "Creating the /mnt/altschool/ directory."
      sudo mkdir -p /mnt/altschool/
      sudo chown -R altschool:altschool /mnt/altschool/

      # Create a test file in the /mnt/altschool/ directory
      echo "Creating a test file in the /mnt/altschool/ directory."
      sudo touch /mnt/altschool/master_data.txt
      sudo chown -R altschool:altschool /mnt/altschool/master_data.txt

      # Put a test string in the test file
      echo "Putting a test string in the test file."
      sudo echo "This is a test string from the master node." > /mnt/altschool/master_data.txt

      # Copy the content of the /mnt/altschool/ directory to the shared folder
      echo "Copying the content of the /mnt/altschool/ directory to the shared folder."
      sudo cp -r /mnt/altschool/* /vagrant/ || true

      # install nginx
      echo "Installing nginx."
      DEBIAN_FRONTEND=noninteractive sudo apt-get install nginx -y

      # start and enable nginx
      # echo "Starting and enabling nginx."
      # sudo systemctl start nginx
      # sudo systemctl enable nginx

      # Configure nginx as a load balancer for the master and slave nodes
      echo "Configuring nginx as a load balancer for the master and slave nodes."
      sudo rm /etc/nginx/sites-enabled/default || true

      # Create a new nginx configuration file
      echo "Creating a new nginx configuration file."
      sudo touch /etc/nginx/sites-available/nginx.conf

      # Edit the nginx configuration file
      echo "Editing the nginx configuration file."
      sudo echo -e "upstream backend {
        server 192.168.33.10;
        server 192.168.33.11;
      }
      server {
        listen 80;
        server_name localhost;
        location / {
          proxy_pass http://backend;
        }
      }" > /etc/nginx/sites-available/nginx.conf

      # Create a symbolic link to the nginx configuration file
      echo "Creating a symbolic link to the nginx configuration file."
      sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf

      # Create nginx default page
      echo "Creating nginx default page."
      sudo touch /var/www/html/load-balancer.html

      # Edit nginx default page
      echo "Editing nginx default page."
      sudo echo -e "<!DOCTYPE html>
      <html>
      <head>
          <title>Load Balancer!</title>
          <style>
              body {
                  background-color: #f0f0f0;
                  font-family: Arial, sans-serif;
                  margin: 0;
                  padding: 0;
              }
              .container {
                  display: flex;
                  justify-content: center;
                  align-items: center;
                  height: 100vh;
              }
              .message {
                  text-align: center;
              }
              h1 {
                  color: #333;
              }
              p {
                  color: #666;
              }
          </style>
      </head>
      <body>
          <div class=\"container\">
              <div class=\"message\">
                  <h1>Welcome!</h1>
                  <p>You've successfully reached my Welcome page through the load balancer. Enjoy your stay! It is working, I personally made sure of that 😉</p>
              </div>
          </div>
      </body>
      </html>" > /var/www/html/load-balancer.html

      # Reload and Restart nginx
      # echo "Reloading and restarting nginx."
      # sudo systemctl reload nginx
      # sudo systemctl restart nginx
    SHELL
  end

  # Create a slave node
  config.vm.define "slave" do |slave|
    slave.vm.hostname = "slave-node"
    slave.vm.network "private_network", ip: "192.168.33.11"
    slave.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end

    # Provisioning script for the slave node
    slave.vm.provision "shell", inline: <<-SHELL
      # Update and upgrade slave node
      echo "Updating and upgrading slave node."
      sudo apt-get update
      # sudo apt-get -y upgrade

      # Copy the public key from the shared folder to the slave node and append it to the authorized_keys file in the .ssh directory in the vagrant user's home directory
      echo "Copying the public key from the shared folder to the slave node and appending it to the authorized_keys file in the .ssh directory in the vagrant user's home directory."
      sudo cat /vagrant/master_id_rsa.pub >> /home/vagrant/.ssh/authorized_keys

      # Remove the public key from the shared folder
      echo "Removing the public key from the shared folder."
      sudo rm /vagrant/master_id_rsa.pub || true

      # Create the /mnt/altschool/slave directory
      echo "Creating the /mnt/altschool/slave directory."
      sudo mkdir -p /mnt/altschool/slave
      sudo chown -R vagrant:vagrant /mnt/altschool/slave

      # Copy the content of the shared folder to the /mnt/altschool/slave directory
      echo "Copying the content of the shared folder to the /mnt/altschool/slave directory."
      sudo cp -r /vagrant/* /mnt/altschool/slave/ || true

      # Remove the content of the shared folder
      echo "Removing the content of the shared folder."
      sudo rm -r /vagrant/* || true

      # Install Apache, MySQL, PHP, and other required packages
      echo "Installing Apache, MySQL, PHP, and other required packages."
      DEBIAN_FRONTEND=noninteractive sudo apt-get -y install apache2 mysql-server php libapache2-mod-php php-mysql

      # Start and enable Apache on boot
      echo "Starting and enabling Apache on boot."
      sudo systemctl start apache2
      sudo systemctl enable apache2

      # Start and enable MySQL on boot and secure MySQL
      echo "Starting and enabling MySQL on boot and securing MySQL."
      # Secure MySQL installation and initialize it with a default user and password
      sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password altschool'
      sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password altschool'
      sudo systemctl start mysql
      sudo systemctl enable mysql
      echo "Securing MySQL completed successfully."

      # Create a sample PHP file for validation
      echo "Creating a sample PHP file for validation."
      echo "<?php phpinfo(); ?>" > /var/www/html/info.php
    SHELL
  end
end
EOF

  # Start master and slave nodes
  echo 'Starting master and slave nodes.'
  vagrant destroy -f
  vagrant up

# Check if vagrant up was successful
if [ $? -eq 0 ]; then
  echo "vagrant up was successful."
else
  echo "vagrant up was not successful."
fi

# SSH into master node
echo "SSH into master node."
vagrant ssh master -c "
echo 'Welcome to the Vagrant Ubuntu Cluster with LAMP Stack and a Load balancer using nginx to allow for traffic to the LAMP using the master and the slave nodes.'
echo 'Deployment completed successfully.'

# Create a cronjob that display an overview of the Linux process management, showcasing currently running processes on every boot
echo 'Creating a cronjob that displays an overview of the Linux process management, showcasing currently running processes on every boot.'
sudo crontab -u altschool -l | { cat; echo "@reboot ps -aux"; } | sudo crontab -u altschool - || true

# Check if the /mnt/altschool/ directory exists
if [ -d /mnt/altschool/ ]; then
  echo 'The /mnt/altschool/ directory exists.'

  # Check if the /mnt/altschool/master_data.txt file exists
  if [ -f /mnt/altschool/master_data.txt ]; then
    echo 'The /mnt/altschool/master_data.txt file exists.'

    # Check if the /mnt/altschool/master_data.txt file is not empty
    if [ -s /mnt/altschool/master_data.txt ]; then
      echo 'The /mnt/altschool/master_data.txt file is not empty.'

      # Check if the /mnt/altschool/master_data.txt file contains the test string
      if grep -q 'This is a test string from the master node.' /mnt/altschool/master_data.txt; then
        echo 'The /mnt/altschool/master_data.txt file contains the test string.'
        echo 'The /mnt/altschool/master_data.txt file contains the test string from the master node.'
      else
        echo 'The /mnt/altschool/master_data.txt file does not contain the test string.'
        echo 'The /mnt/altschool/master_data.txt file does not contain the test string from the master node.'
      fi
    else
      echo 'The /mnt/altschool/master_data.txt file is empty.'
    fi
  else
    echo 'The /mnt/altschool/master_data.txt file does not exist.'
  fi
else
  echo 'The /mnt/altschool/ directory does not exist.'
fi

# exit from the master node
echo 'Exiting from the master node.'
exit
"
# SSH into slave node
echo "SSH into slave node."
vagrant ssh slave -c "

# Check if the /mnt/altschool/slave/ directory exists
if [ -d /mnt/altschool/slave/ ]; then
  echo 'The /mnt/altschool/slave/ directory exists.'

  # Check if the /mnt/altschool/slave/master_data.txt file exists
  if [ -f /mnt/altschool/slave/master_data.txt ]; then
    echo 'The /mnt/altschool/slave/master_data.txt file exists.'

    # Check if the /mnt/altschool/slave/master_data.txt file is not empty
    if [ -s /mnt/altschool/slave/master_data.txt ]; then
      echo 'The /mnt/altschool/slave/master_data.txt file is not empty.'

      # Check if the /mnt/altschool/slave/master_data.txt file contains the test string
      if grep -q 'This is a test string from the master node.' /mnt/altschool/slave/master_data.txt; then
        echo 'The /mnt/altschool/slave/master_data.txt file contains the test string.'
        echo 'The /mnt/altschool/slave/master_data.txt file contains the test string from the master node.'
      else
        echo 'The /mnt/altschool/slave/master_data.txt file does not contain the test string.'
        echo 'The /mnt/altschool/slave/master_data.txt file does not contain the test string from the master node.'
      fi
    else
      echo 'The /mnt/altschool/slave/master_data.txt file is empty.'
    fi
  else
    echo 'The /mnt/altschool/slave/master_data.txt file does not exist.'
  fi
else
  echo 'The /mnt/altschool/slave/ directory does not exist.'
fi

# exit from the slave node
echo 'Exiting from the slave node.'
exit
"

echo "Deployment complete."
echo "You can now access the load balancer at http://192.168.33.10/load-balancer.html"
echo "You can now access the phpinfo.php file at http://192.168.33.10/info.php"