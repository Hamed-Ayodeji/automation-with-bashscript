# Automating the setup of a simple load-balanced environment using Vagrant and Nginx with Bash script

This repository contains a Bash script and Vagrant configuration for setting up a simple load-balanced environment using Vagrant and Nginx. The environment includes a master node, a slave node, and a load balancer.

## Prerequisites

Before running the script, ensure you have the following prerequisites:

- [Vagrant](https://www.vagrantup.com/downloads) installed
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) installed
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) installed (if cloning the repository)

## Getting Started

1. Clone this repository (if not done already) using Git:

   ```bash
   git clone https://github.com/Hamed-altschool/Cloud_second_sems_bashscript_project.git
   cd Cloud_second_sems_bashscript_project
   ```

2. Open your terminal and navigate to the project directory.

3. Run the Bash script to create and provision the Vagrant environment:

   ```bash
   bash provision_vagrant.sh
   ```

   The script will set up the master node, slave node, and load balancer with Nginx. It will also deploy a sample HTML page.

4. After the script completes, you can access the load balancer at:

   `http://192.168.56.7/load-balancer.html`

5. Additionally, you can access the PHP info page at:

   `http://192.168.56.5/info.php`

## Documentation

The documentation for this project is available [here](./Documentation.md).

## Configuration

The main Vagrant configuration is defined in the `Vagrantfile`. The script provisions three virtual machines:

- `master` - The master node
- `slave` - The slave node
- `load_balancer` - The load balancer with Nginx

Nginx is configured as a load balancer, distributing traffic between the master and slave nodes.

## Notes

- The provisioning script assumes that VirtualBox and Vagrant are installed. The script will check for dependencies and install them if needed. However, this check is commented out because the provided environment is on Windows, and the installation may differ.

- Be aware that this script is designed for a specific setup and might need adjustments for different environments.

Feel free to explore the repository, documentation, and test pages and adapt the scripts for your specific requirements. If you encounter any issues or have questions, please [open an issue](https://github.com/Hamed-altschool/Cloud_second_sems_bashscript_project/issues).

Enjoy your load-balanced Vagrant environment!
