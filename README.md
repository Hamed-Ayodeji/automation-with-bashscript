# Vagrant Ubuntu Cluster with LAMP Stack on Master and Slave Nodes, and Load Balancer

## Overview

This Bash script automates the setup of a Vagrant cluster with two nodes, one acting as a master and the other as a slave. Both nodes are configured with a LAMP (Linux, Apache, MySQL, PHP) stack. Additionally, a load balancer is installed on the master node using Nginx to distribute incoming traffic between the master and slave nodes.

## Prerequisites

Before running this script, ensure you have the following prerequisites:

1. [Vagrant](https://www.vagrantup.com/) installed.
2. [VirtualBox](https://www.virtualbox.org/) installed.
3. A Windows test environment (if running on Windows).

## Usage

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

6. Upon successful completion, you can access the following resources:

   - Load Balancer: [http://192.168.33.10/load-balancer.html](http://192.168.33.10/load-balancer.html)
   - PHP Info: [http://192.168.33.10/info.php](http://192.168.33.10/info.php)

## Script Explanation

The script performs the following actions:

1. Checks for and installs required dependencies (commented out for Windows).

2. Creates a `Shared_folder` directory.

3. Checks for the existence of a `Vagrantfile` and removes it if present.

4. Creates a new `Vagrantfile` with predefined configuration settings.

5. Starts and provisions two nodes: "master" and "slave," both with the LAMP stack installed, each with specific settings and provisioning scripts.

6. SSHs into the master node to perform the following tasks:
   - Display an overview of running processes.
   - Creates a cron job that runs the ps aux command at every boot
   - Checks for the existence of directories and files.
   - Validates the content of the test file.

7. SSHs into the slave node to perform similar directory and file checks.

8. Displays the URLs to access the load balancer and PHP info pages.

## Troubleshooting

If you encounter any issues during the script execution, please check the following:

- Ensure that Vagrant and VirtualBox are installed correctly.
- Review the script's output and error messages for clues on what went wrong.

## Notes

- The script contains conditional checks for dependency installation, which are commented out since they are tailored for Ubuntu environments. You may uncomment and adapt these sections if you run the script on Ubuntu.
- Nginx is installed as the load balancer, but the configuration to start and enable it is commented out. Uncomment and configure it as needed.
