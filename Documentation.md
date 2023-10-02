# Vagrant Ubuntu Cluster with LAMP Stack on Master and Slave Nodes, and Load Balancer

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Getting Started](#getting-started)
4. [Script Overview](#script-overview)
5. [Usage](#usage)
6. [Troubleshooting](#troubleshooting)
7. [Notes](#notes)

## 1. Introduction

This documentation provides a comprehensive guide for setting up a Vagrant cluster with two nodes: one acting as a master and the other as a slave. Both nodes are configured with a LAMP (Linux, Apache, MySQL, PHP) stack. Additionally, a load balancer is installed on the master node using Nginx to distribute incoming traffic between the master and slave nodes.

## 2. Prerequisites

Before you begin, ensure you have the following prerequisites:

- [Vagrant](https://www.vagrantup.com/) installed.
- [VirtualBox](https://www.virtualbox.org/) installed.
- A Windows test environment (if running on Windows).

## 3. Getting Started

Follow these steps to set up the Vagrant cluster with the LAMP stack and load balancer:

1. Clone this repository or copy the Bash script to your local machine.

2. Open a terminal and navigate to the directory containing the script.

3. Make the script executable:

   ```bash
   chmod +x deploy_ubuntu_cluster.sh
   ```

4. Run the script:

   ```bash
   ./deploy_ubuntu_cluster.sh
   ```

5. Follow the on-screen instructions during script execution.

## 4. Script Overview

The script is designed to automate the setup of a Vagrant cluster with specific configurations. Here's a detailed breakdown of the script's actions:

### 4.1. Dependency Checks (Optional)

- The script checks for the presence of required dependencies, such as Vagrant and VirtualBox. Note that dependency installation is commented out, as it's tailored for Ubuntu environments. You may uncomment and adapt these sections if you run the script on Ubuntu.

### 4.2. Directory Creation

- The script creates a `Shared_folder` directory where shared files between the nodes will be stored.

### 4.3. Vagrantfile Management

- Checks for the existence of a `Vagrantfile` and removes it if present.
- Creates a new `Vagrantfile` with predefined configuration settings.

### 4.4. Node Configuration and Provisioning

- The script defines two nodes: "master" and "slave," each with specific settings and provisioning scripts.
- Both nodes are configured with the LAMP stack.

#### Master Node

- Updates the master node and upgrades its packages.
- Creates a user called "altschool" with root privileges.
- Generates an SSH key pair for the "altschool" user without a passphrase.
- Installs Apache, MySQL, PHP, and other required packages.
- Starts and enables Apache and secures MySQL.
- Creates a sample PHP file for validation.
- Creates a directory `/mnt/altschool/` and a test file within it.
- Copies content to the shared folder for access from other nodes.
- Installs Nginx as a load balancer.

#### Slave Node

- Updates the slave node and upgrades its packages.
- Copies the public key from the shared folder and appends it to the `authorized_keys` file.
- Creates a directory `/mnt/altschool/slave/`.
- Copies content from the shared folder to the slave directory.

### 4.5. Cluster Start-Up

- Initiates the start and provisioning of both master and slave nodes.
- Checks if the Vagrant cluster starts successfully.

### 4.6. SSH into Nodes for Validation

- SSHs into the master and slave nodes to perform various validations.
- Checks for the existence of directories and files.
- Validates the content of the test files.

## 5. Usage

Upon successful completion of the script, you can access the following resources:

- Load Balancer: http://192.168.33.10/load-balancer.html
- PHP Info: http://192.168.33.10/info.php

## 6. Troubleshooting

If you encounter any issues during the script execution, consider the following troubleshooting steps:

- Ensure that Vagrant and VirtualBox are installed correctly.
- Review the script's output and error messages for clues on what went wrong.

## 7. Notes

- The script contains conditional checks for dependency installation, which are commented out since they are tailored for Ubuntu environments. Uncomment and adapt these sections if you run the script on Ubuntu.
- Nginx is installed as the load balancer, but the configuration to start and enable it is commented out. Uncomment and configure it as needed.
