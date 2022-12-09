# k8s-kubeadm-ansible
Ansible Playbooks to provision k8s cluster with kubeadm
1 master and multiple worker nodes

## Prerequisites
- Ansible 2.4+
- VirtualBox
- Vagrant

## VM Provisioning with Vagrant
### Setup Environment variables
- Change the directory to `vms`
- Copy .env_example to .env
- Update the variables in .env file as per your environment
- Vagrant plugins
  - vagrant-env (`vagrant plugin install vagrant-env`) 
    - In case you face any issues with vagrant-env installation, you can manually set the environment variables in the shell.
    - Make sure to comment/remove the line `config.env.enable` in the Vagrantfile in case you are not using vagrant-env plugin

### Provision VMs
- Change the directory to `vms`
- Execute the following command to provision VMs
  - `vagrant up`
- Check the VM status
  - `vagrant status`

## Install Kubernetes Cluster with kubeadm using Ansible
### Install Ansible role ansible-role-linux-kubernetes from ansible-galaxy
A big thanks to `Lorenzo Garuti` for building an awesome Ansible role to install k8s cluster with kubeadm.
This role will install kubernetes cluster with kubeadm on the VMs provisioned with Vagrant. 
You can follow the steps to install this role from https://github.com/garutilorenzo/ansible-role-linux-kubernetes

Quickstart guide to install `ansible-role-linux-kubernetes` from ansible-galaxy:
- ansible, ipaddr and netaddr python modules are required to be installed on the host machine. You can execute the below command to install these modules.
  - `pip install ansible ipaddr netaddr`
- Change the directory to k8s-cluster-kubeadm
  - `cd k8s-cluster-kubeadm`
- Create a directory `roles` in the current directory
  - `mkdir roles`
- Execute the following command to install ansible-role-linux-kubernetes from ansible-galaxy
  - `ansible-galaxy install git+https://github.com/garutilorenzo/ansible-role-linux-kubernetes.git -p roles/`

### Prepare the Ansible hosts inventory file
- Copy `inventory/k8s-cluster/k8s-hosts_example.ini` to `inventory/k8s-cluster/k8s-hosts.ini`
- Update the ansible hosts inventory file in `inventory/k8s-cluster/k8s-hosts.ini` as per your environment

### Update the Ansible role variables if required 
- If needed, update the variables in `group_vars/all/vars.yml` as per your environment

### Execute the Ansible playbook to install kubernetes cluster with kubeadm
- Make sure you are in the directory `k8s-cluster-kubeadm`
- `ansible-playbook create-k8s-cluster.yml -i inventory/k8s-cluster/k8s-hosts.ini -e kubernetes_init_host=<Hostname of master as specified in the inventory file>`
  - Example: `ansible-playbook create-k8s-cluster.yml -i inventory/k8s-cluster/k8s-hosts.ini -e kubernetes_init_host=master`