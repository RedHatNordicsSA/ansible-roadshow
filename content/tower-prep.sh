#!/bin/bash
# Magnus Glantz, sudo@redhat.com, 2018
# Tower prereqs

# RPM prereqs
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install wget bind-utils ansible

# SSH key prereqs, creation of users for demo
# Create directory for ssh public key
if [ ! -d /root/.ssh ]; then
  mkdir /root/.ssh
  chmod 600 /root/.ssh
fi

# Create ssh key
cat << 'EOF' >/root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCR/+C0do9cM9edqeG8y81HQHmPAiviI3s2HDhLPMfSZ9iqxwS/2Cpt1TDfVVh+Qoo3mVgSe6Y7jlX6TNeG2aFQfCG33/3l3OZaACheAzJZ+vsL+OnIMT8sdzkqkYPeE5yeuutsDzdPj9a6nr/HIn6/BV2GFHCqxP7NswW7v1q8n56ucMto+GU2Ih0pIkEOIbjdQ83npRtukeTtPBIBVQJY7XI6bnbf7m6dJ5sAKe94EnOCqR3h7p19+mrmDNXi7vnWBFIu6ctfsUXEHDewGny6b3A/UKk5x1EGsIPuZkbdXBKDF9nw39171jldawiEN3XLQbG2mcrZ6l/cVlV8be0D
EOF
chmod 600 /root/.ssh/authorized_keys

curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa >/root/.ssh/id_rsa
curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa.pub >/root/.ssh/authorized_keys
chmod 600 /root/.ssh/*
curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/tower-inventory >/root/tower-inventory
curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/inventory >/root/inventory
curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/tower-install.yml >/root/tower-install.yml
	
for i in {1..50}; do
	useradd user$i
	mkdir /home/user$i/.ssh
	chmod 700 /home/user$i/.ssh
	curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa >/home/user$i/.ssh/id_rsa
	curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa.pub >/home/user$i/.ssh/authorized_keys
	chmod 600 /home/user$i/.ssh/*
	chown user$i:user$i /home/user$i/.ssh -R
done

# Install Ansible tower
ansible-playbook -i /root/tower-inventory /root/tower-install.yml
