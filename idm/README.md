# IDM Demo env installer

This is a simple demo environment provisioner for IdM to install.
It creates:
- libvirt-network with DHCP/DNS
- libvirt-pool for your VMS
- idm-server.<your-domain> VM with IdM installed and configured with DNS/adtrust
- idm-client.<your-domain> VM with IdM configured to work as a client to idm-server

## VM setup

VM setup is based on Terraform, it instantiates two virtual machine, *idm-server* and *idm-client*, kickstarting the setup.

First you need to download and install Terraform:

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install terraform

Then you need to download the FULL RHEL8 image and link it in the modules folder and create a symbolic link in the modules folder:

    ln -s /path/to/iso terraform/modules/01_idm_server/rhel8.iso
    ln -s /path/to/iso terraform/modules/02_rhel_client/rhel8.iso

Review settings in **idm.tfvars** file, containing some basic inputs:

    network_cidr = ["192.168.210.0/24"]
    domain = "rhdemo.labs"
    libvirt_network = "vm-net"
    libvirt_pool = "vm-pool"
    disk_size = 40

The terraform plan also creates an isolated virtual network, with DHCP and DNS for the specified domain.

From *terraform* directory, initialize the plugins:
    
    terraform init

Then apply the plan:

    terraform apply -var-file='idm.tfvars'

The setup will take a bit as it is a full install with a kickstarter. 

## IdM setup

Once your VMs are up and running I prepared an execution-environment to use with Ansible, to use freeipa.ansible_freeipa collection to provision both server and client.

From the *idm* folder, build your execution-environment:

    ansible-builder build -c ansible/execution-environment/context -f ansible/execution-environment/execution-environment.yml -t ansible-execution-env

Edit *ansible/inventory* file if you need fine tuning on attributes (i.e. if you changed the domain):

    [ipaserver]
    idm-server.rhdemo.labs

    [ipaclients]
    idm-client.rhdemo.labs

    [ipaservers]
    idm-server.rhdemo.labs

    [ipaserver:vars]
    ipaserver_domain=rhdemo.labs
    ipaserver_realm=RHDEMO.LABS
    ipaserver_setup_dns=yes
    ipaserver_setup_adtrust=yes
    ipaserver_auto_forwarders=yes
    ipaadmin_password=admin123
    ipadm_password=admin123

    [ipaclients:vars]
    ipaclient_domain=rhdemo.labs
    ipaclient_realm=RHDEMO.LABS
    ipaserver_domain=rhdemo.labs
    ipaserver_realm=RHDEMO.LABS
    ipaadmin_principal=admin
    ipaadmin_password=admin123
    ipassd_enable_dns_updates=true

Then launch the playbook to install **idm-server**:

    ansible-navigator run -m stdout --eei=ansible-execution-env --pp never --pae false -i ansible/inventory ansible/idm-server-setup.yml 

If you want to configure the client to connect to idm-server launch the playbook to setup **idm-client**:

    ansible-navigator run -m stdout --eei=ansible-execution-env --pp never --pae false -i ansible/inventory ansible/idm-client-setup.yml 


## Test your configuration

If the setup was good, you will be able to access your IdM server on https://idm-server.<your-domain>