# Comprehensive Documentation for the "deploy_ubuntu_cluster.sh" Bash Script

Welcome to the comprehensive documentation for the `deploy_ubuntu_cluster.sh` Bash script. This documentation provides a detailed explanation of the script's purpose and functionality, as well as step-by-step instructions for setting up a Vagrant environment with three nodes: a master node, a slave node, and a load balancer node. The nodes are configured with a LAMP (Linux, Apache, MySQL, PHP) stack, and the load balancer node is equipped with Nginx for efficient traffic distribution.

## Table of Contents

1. [Introduction](#1-introduction)
2. [Prerequisites](#2-prerequisites)
3. [Script Overview](#3-script-overview)
    - [Installation of Dependencies](#31-installation-of-dependencies)
    - [Directory and File Operations](#32-directory-and-file-operations)
    - [Vagrant Configuration](#33-vagrant-configuration)
    - [Provisioning the Master Node](#34-provisioning-the-master-node)
    - [Provisioning the Slave Node](#35-provisioning-the-slave-node)
    - [Provisioning the Load Balancer Node](#36-provisioning-the-load-balancer-node)
4. [Running the Script](#4-running-the-script)
5. [Accessing the Web Pages](#5-accessing-the-web-pages)
6. [Conclusion](#6-conclusion)

## 1. Introduction

The `deploy_ubuntu_cluster.sh` Bash script automates the setup of a Vagrant environment, creating a multi-node cluster. The objective is to orchestrate the automated deployment of two Vagrant-based Ubuntu systems, designated as 'Master and Slave' with an integrated LAMP stack on both systems and a lot of other specifications one of which is creating a load balancer using Nginx to allow for traffic to the LAMP using the master and the slave nodes. The environment consists of three nodes:

- A **Master Node**: Running a LAMP stack.
- A **Slave Node**: Also running a LAMP stack.
- A **Load Balancer Node**: Configured with Nginx to distribute incoming web traffic to the master and slave nodes.

This documentation will guide you through the entire process.

## 2. Prerequisites

Before using this script, make sure you have the following prerequisites:

- **Vagrant**: Install Vagrant from [here](https://www.vagrantup.com/downloads).

- **VirtualBox**: Install VirtualBox from [here](https://www.virtualbox.org/).

- A **Linux Environment**: This script is intended for a Linux-based environment.

## 3. Script Overview

The script is divided into several sections, each addressing different aspects of the environment setup. The following sections provide a brief overview of each section.

### 3.1 Installation of Dependencies

This section ensures that the required dependencies (Vagrant and VirtualBox) are installed. If not already installed, the script automatically installs them. It also checks if the Vagrant environment is already running and stops it if it is. This is to ensure that the script runs smoothly without any errors.

### 3.2 Directory and File Operations

This section manages the project directory structure. It removes previous Vagrant-related files and directories and creates the necessary project structure. It also copies the Vagrantfile and the provisioning script to the project directory. The script also creates a shared folder for data sharing between the master and slave nodes. The shared folder is created in the project directory and is accessible from both the master and slave nodes.

### 3.3 Vagrant Configuration

The script defines the Vagrantfile to configure the virtual machines. It specifies settings for the master, slave, and load balancer nodes, including hostname, IP addresses, and resource allocation.

### 3.4 Provisioning the Master Node

This part configures the master node and includes several essential tasks:

- Updating and upgrading the master node's packages.
- Creating a user account named 'altschool' with root privileges.
- Generating an SSH key pair for the 'altschool' user (without a passphrase).
- Installing Apache, MySQL, PHP, and other required packages.
- Starting and enabling Apache and MySQL services.
- Creating a sample PHP file for validation.
- Creating a test file and copying it to a shared folder for data sharing.

### 3.5 Provisioning the Slave Node

This section replicates the software stack on the slave node and configures SSH key access:

- Copying the public key from the shared folder to the slave node and appending it to the authorized_keys file in the `.ssh` directory.
- Creating directories for shared data.
- Copying the content of the shared folder to the slave node's directories.

### 3.6 Provisioning the Load Balancer Node

This section configures the load balancer node using Nginx:

- Installing Nginx.
- Creating an Nginx configuration file for load balancing.
- Creating a symbolic link to the configuration file.
- Creating an HTML file to test the load balancer page.
- Starting and enabling Nginx.

## 4. Running the Script

Before running the script, make sure you are in the same directory as the script file. Execute the script by running:

```bash
./deploy_ubuntu_cluster.sh
```

This will start the process of creating the virtual machines and configuring the environment.

## 5. Accessing the Web Pages

You can access the web pages once the servers are up and running. Use the following URLs in your web browser:

- **Load Balancer Page**: Access the load balancer page at [http://192.168.56.7/load-balancer.html](http://192.168.56.7/load-balancer.html).

- **PHP Info Page**: Access the PHP info page at [http://192.168.56.5/info.php](http://192.168.56.5/info.php).

## 6. Conclusion

This comprehensive documentation provides an in-depth understanding of the `deploy_ubuntu_cluster.sh` Bash script, its purpose, and functionality. It guides you through the entire setup process and how to access the web pages served by the cluster. We hope this documentation enables you to explore and experiment with your cluster environment efficiently.

Happy clustering!
