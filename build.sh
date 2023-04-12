#!/bin/bash

# Install Ansible
sudo apt update
sudo apt install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Clone the deployment repository
git clone https://github.com/your_username/your_deployment_repo.git
cd your_deployment_repo

# Run the Ansible playbook
ansible-playbook -i inventory.ini playbook.yml
