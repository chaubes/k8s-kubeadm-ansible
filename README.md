# k8s-kubeadm-ansible
If you are new to or learning Kubernetes, you would often like to quickly spin up a Kubernetes cluster on your local machines. You could do that with minikube or kind, but if you are keen to learn how to install, manage, administer, upgrade, and backup a Kubernetes cluster, setting it up with kubeadm is a great option.

The purpose of this repository is to enable the provisioning/teardown of a Kubernetes cluster built with `kubeadm` on your local machines using Vagrant, VirtualBox and Ansible playbooks.

- **k8s cluster configuration:** One master and multiple worker nodes
- **Virtual VM provisioning:** Using Vagrant and VirtualBox
- **Creation/teardown of k8s cluster:** Using Ansible playbooks

_**Note:** The Kubernetes cluster created with this repository is NOT meant for production use. It is meant for learning and development purposes only._ 

## Prerequisites
Install the following softwares on your local machine:
- Ansible 2.4+
- VirtualBox
- Vagrant

## VM Provisioning with Vagrant
### Setup Environment variables
- Make sure you are in the directory `vms`
- Copy `.env_example` to `.env`
- If required, update the variables in `.env` file as per your environment
- Make sure to populate the `SSH_KEY_PATH` variable with the path to your ssh key which you will use to ssh into the VMs
- Install Vagrant plugins
  - vagrant-env (`vagrant plugin install vagrant-env`) 
    - In case you face any issues with vagrant-env installation, you can manually set the environment variables in the shell from where you are running `vagrant` commands
    - Make sure to comment/remove the line `config.env.enable` in the Vagrantfile in case you are not using `vagrant-env` plugin

### Provision Virtual VMs
- Make sure you are in the directory `vms`
- Execute the following command to provision VMs
  - `vagrant up`
- Check the VM status
  - `vagrant status`
- Make sure the VMs are up and running before proceeding to the next step

## Install Kubernetes Cluster with kubeadm using Ansible
### Install Ansible role ansible-role-linux-kubernetes from ansible-galaxy
A big thanks to [Lorenzo Garuti](https://github.com/garutilorenzo) for building an awesome Ansible role to install k8s cluster with kubeadm.
This role will install kubernetes cluster with kubeadm on the VMs provisioned with Vagrant. 
You can follow the steps to install this role from https://github.com/garutilorenzo/ansible-role-linux-kubernetes

Quickstart guide to install `ansible-role-linux-kubernetes` from ansible-galaxy:
- ansible, ipaddr and netaddr python modules are required to be installed on the host machine. You can execute the below command to install these modules.
  - `pip install ansible ipaddr netaddr`
- Change the directory to `k8s-cluster-kubeadm`
  - `cd k8s-cluster-kubeadm`
- Execute the following command to install ansible-role-linux-kubernetes from ansible-galaxy
  - `ansible-galaxy install git+https://github.com/garutilorenzo/ansible-role-linux-kubernetes.git -p roles/`

### Prepare the Ansible hosts inventory file
- Copy `inventory/k8s-cluster/k8s-hosts_example.ini` to `inventory/k8s-cluster/k8s-hosts.ini`
- You can get the details of the VMs provisioned with Vagrant by executing the following command from the `vms` directory
  - `vagrant ssh-config`
- Update the ansible hosts inventory file in `inventory/k8s-cluster/k8s-hosts.ini` as per your environment

### Update the Ansible role variables if required 
- If needed, update the variables in `group_vars/all/vars.yml` as per your environment
  - Default value of kubernetes_version is `1.25.0`, you can update this variable to install a different version of kubernetes

### Execute the Ansible playbook to install kubernetes cluster with kubeadm
- Make sure you are in the directory `k8s-cluster-kubeadm`
- `ansible-playbook create-k8s-cluster.yml -i inventory/k8s-cluster/k8s-hosts.ini -e kubernetes_init_host=<Hostname of master as specified in the inventory file>`
  - Example: `ansible-playbook create-k8s-cluster.yml -i inventory/k8s-cluster/k8s-hosts.ini -e kubernetes_init_host=master`
- Check the status of the kubernetes cluster, you should see the master and worker nodes in the Ready state. Might take a minute or two for the nodes to be in the Ready state.
  - `kubectl get nodes`
- Check the status of the pods in the kube-system namespace
  - `kubectl get pods -n kube-system`
- You should be able to run the `kubectl` commands after sshing into the master node with the user specified in the inventory file
  - `vagrant ssh master`
  - `kubectl get nodes`
- The alias `k` is set for the `kubectl` command in the master node, you can use the alias to run the `kubectl` commands
  - `k get nodes`
- If you want to automate the setup  of utilities to manage the kubernetes cluster like `kubectx`, `kube auto-bashcompletion`, you can add these tasks in the `kubetools-install` ansible playbook
- Once you are done working with the kubernetes cluster, you can execute the following command from the `vms` directory to power off the Vagrant VMs
  - `vagrant halt`
- To bring the cluster backup, you can execute the following command from the `vms` directory
  - `vagrant up`
- You can also execute the following command to destroy the Vagrant VMs. This will delete the VMs and all the data in the VMs.
  - `vagrant destroy`

## Un-install/teardown kubernetes cluster with ansible
- Make sure you are in the directory `k8s-cluster-kubeadm`
- `ansible-playbook uninstall-k8s-cluster.yml -i inventory/k8s-cluster/k8s-hosts.ini`

_In case you face any iptables related issues while re-installing the Kubernetes cluster after running the Un-install playbook, you can either re-provision the Vagrant VMs or update `vars.yml` file to use a different subnet for the kubernetes cluster._