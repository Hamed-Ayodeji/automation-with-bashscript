# Automating My Vagrant Ubuntu Cluster with LAMP Stack and Nginx Load Balancer

Hello! I'm thrilled to guide you through setting up an entirely automated Vagrant-based Ubuntu cluster with a LAMP (Linux, Apache, MySQL, PHP) stack and an Nginx load balancer. This meticulously crafted script will take care of everything effortlessly.

## Getting Started

Before we dive into the script, let's ensure I have everything I need:

- *Vagrant*: This essential tool will manage my virtual machines.
- *VirtualBox*: VirtualBox, my trusted virtualization provider for Vagrant. If I'm on Windows, I'll consider using the Windows Subsystem for Linux (WSL) or a Linux-based environment.

## The Script in Detail

Let's delve into each step of the script, which is fully automated:

### 1. Installing Dependencies (Commented Out)

In a Linux environment, I'd check if Vagrant and VirtualBox are installed and install them if necessary. However, this part is skipped on Windows.

### 2. Removing Existing Vagrantfile

I start fresh by removing any old Vagrantfile in the current directory.

### 3. Creating a New Vagrantfile

I create a fresh Vagrantfile that defines how my virtual machines will be set up.

### 4. Configuring Vagrantfile

This is where the magic happens. I configure my Vagrantfile to create two virtual machines: a master node and a slave node, both based on the "bento/ubuntu-20.04" box.

### 5. Provisioning the Master Node

I dive into the master node's setup, which is fully automated. Here are the key details:

- I install essential packages like Apache, MySQL, PHP, and Nginx.
- I create a new user, grant them sudo privileges, and enable password-less SSH.
- I set up a sample PHP file for validation.
- I configure it to run `ps aux` on startup.

### 6. Provisioning the Slave Node

The slave node receives similar treatment with package installations and SSH key setup. I also ensure seamless SSH communication from the master.

### 7. Configuring Nginx as Load Balancer

Nginx plays a pivotal role in my setup. I configure it as a load balancer, distributing traffic between the master and slave nodes for redundancy and scalability.

### 8. Testing and Verification

To ensure everything runs smoothly, I perform automated checks on both nodes. I verify the creation of directories, files, and content to guarantee an error-free setup.

### 9. Access Information

I provide you with URLs to access the load balancer and the PHP info page.

## Running the Script

To get started:

1. Make sure I've met the prerequisites.
2. I place this script in the directory where I want to set up my Vagrant cluster.
3. I run the script using my Bash shell.

## Accessing the Services

Here are the URLs to access my services:

- *Load Balancer*: [http://192.168.33.10/load-balancer.html](http://192.168.33.10/load-balancer.html)
- *PHP Info Page*: [http://192.168.33.10/info.php](http://192.168.33.10/info.php)

## Troubleshooting

If I encounter any issues along the way, I'll double-check that I've met the prerequisites and review this script for potential errors.

## Conclusion

This script is my trusty companion for automating the setup of a Vagrant-based cluster with a LAMP stack and an Nginx load balancer. It takes care of everything, providing a hassle-free clustered development environment.

Feel free to customize this script to suit your specific needs or expand upon it to include additional configurations.

*Deployment completed successfully. Enjoy your fully automated clustered development journey!*
