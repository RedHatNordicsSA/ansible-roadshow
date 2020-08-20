#!/bin/bash
# Magnus Glantz, sudo@redhat.com, 2020
# Tower prereqs

# RPM prereqs
yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
ITER=0
while true; do
  if [ "$ITER" -eq 10 ]; then
    echo "This is never going to work."
    break
  fi
  rpm -q epel-release
  if [ "$?" -eq 0 ]; then
    echo "EPEL installed, going forward with install."
    break
  else
    sleep 30
    yum clean all
    yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
    rpm -q epel-release
    if [ "$?" -eq 0 ]; then
      echo "EPEL installed, going forward with install."
      break
    else
      ITER=$(expr $ITER + 1)
    fi
  fi
done

yum -y install gcc python2-pip wget bind-utils ansible nano vim screen emacs joe

ITER=0
while true; do
  if [ "$ITER" -eq 10 ]; then
    echo "This is never going to work."
    break
  fi
  rpm -q ansible
  if [ "$?" -eq 0 ]; then
    echo "Ansible installed, going forward with install."
    break
  else
    sleep 30
    yum clean all
    yum -y install gcc python2-pip wget bind-utils ansible nano vim screen emacs joe
    rpm -q ansible
    if [ "$?" -eq 0 ]; then
      echo "Ansible installed, going forward with install."
      break
    else
      ITER=$(expr $ITER + 1)
    fi
  fi
done

# SSH key prereqs, creation of users for demo
# Create directory for ssh public key
if [ ! -d /root/.ssh ]; then
  mkdir /root/.ssh
  chmod 600 /root/.ssh
fi

useradd student
echo "RHforum20Pass" | passwd student --stdin
mkdir /home/student/.ssh

for THEDIR in /home/student/.ssh/id_rsa /root/.ssh/id_rsa; do
cat << 'EOF' >$THEDIR
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA0VSEb5QMEOKW8MiEo/UXpKcouoSknmMxgpmRtz6u/5oP3HpB
4YFkUqhTjNdwLCs0eo4khVO9/on0EjNIPKIt0febBQ2OEHhl2rLc4kN2h1IqONGL
XhP5VAA2kcgcu8No5p7tPrHt4yvMMpqtjMGhW07THlAbzITr7rnYbxtXAf83B9Ey
52nU1vjqprtgrzaVJaatQyIiNdF1KYWh6RExXzmMiEO0k4ohHeIp5N4j8vMxps4E
JHiuNXK8+hDXgZ4/LYC+KNqzJmFpUYI4/7fHtrFA898BFcQtiYWQ3sLmeiJidsjS
7fvMjoXNpE7t6KOKWdn/5HQqJan/wTFzrXz+QQIDAQABAoIBAQCU5fKCT6O5iwPk
6Cz5V0hnFYQyEFHsXBCGnmf5GXxvUg4APXKJTnmnFhbAMyqWMHFWz68Iq4WU/ln/
bDzw7Ed9eAvrrzWjX5DL3LijtWslXHuuCNeCpuCOMMygK+DManY+vUNyeiwFkEzi
ngXe/oihI1Om10K+2rncCJP8jEz6nF6luFEBkJNkRJ9v5+2Hw6fj62zgFyB8AN+i
WezXZTGgcRUcC8rv5riQpU/V+9cJ/1M2MtpfwhZONJnn0Ei+QmX9AHpeMVh8Gw2f
b4un4rks130Jl7AAyLnAfsvteAHngDfJhfV4jntMXdG8DFzaAW8mUZBjq+fYHbL7
yFCrh1mxAoGBAPQLSI6Z2XSmSRDInV/EvPJaJR7R0dGPGUOZ34UY7ePn6zPfu52e
q+zEts2VwwKG+a7GR/32mulF21nk3LskvyKPx/9+yVLVTcCHZrvkGCVNbnOAdAIQ
Y8yOSOVbVoNKlWV6j4wDkso4cfH/j5gcqEY4knjcJjViqEcWSq4BxiFtAoGBANuV
3SAdx1obPJ+PlJX90L1LRsU5PUoESGBgHGIZKLH4FEaKfOGpoUi4URn2v6K0d3sg
JfwPc5WKye+s6Y3opFQqoIOVG7DvkNMOKdDQOO5SyS0YzaHddx82mQTqHEN4HZLq
zk/9iZ0Bv6C951jhi5gslo13neY98BIpLwcQql+lAoGAPrVHh5zwy5CO5ckm5xze
kEepkinICFkE3OIFFWY6en11anbq9q127/f8IQeCfHvCXK6GgTOEyrwwiQDN1yiy
FGdttLEXejllKTuholYR/kPPRc6UAJPFkSJeiNDXghUAHntHt2qTpXKrlMteUm/K
rYCL4pJvHvii1OFdfyjliGECgYEAxz9eDYVX3bg3MyWqkstjvE/w4IbGyUHHlsO/
HXhsx8guRa/mDzHHql+tH50ZWH7ep7eNIAG5RKlSAQvqRR0i90hSq/MB1HQc+pWw
dcxqzD4MU8Jc3JJDQ+xbvuzbRpFYbHZpTIXnd7MdebK3mJvX+fYDikxO15u+GgyK
oqOJpQ0CgYBYb2mmQc/xpk/JSd9WRZWu8/KC/68gcMiVScfW2x6gWxWWaMu9ro9y
FqFZ/vfzypA1isLLp0kVDH195rbjZ7B78DtCLLX8crCSr2U0rXvSQUGqDVJHSVtC
uY+57Bccfa3Z4lvmRl9ODPpPJhBhlX3694yzxSruue2Ri6UXr/vuNA==
-----END RSA PRIVATE KEY-----
EOF
done

for THEDIR in /home/student/.ssh/authorized_keys /root/.ssh/authorized_keys; do
cat << 'EOF' >$THEDIR
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRVIRvlAwQ4pbwyISj9Rekpyi6hKSeYzGCmZG3Pq7/mg/cekHhgWRSqFOM13AsKzR6jiSFU73+ifQSM0g8oi3R95sFDY4QeGXastziQ3aHUio40YteE/lUADaRyBy7w2jmnu0+se3jK8wymq2MwaFbTtMeUBvMhOvuudhvG1cB/zcH0TLnadTW+Oqmu2CvNpUlpq1DIiI10XUphaHpETFfOYyIQ7STiiEd4ink3iPy8zGmzgQkeK41crz6ENeBnj8tgL4o2rMmYWlRgjj/t8e2sUDz3wEVxC2JhZDewuZ6ImJ2yNLt+8yOhc2kTu3oo4pZ2f/kdColqf/BMXOtfP5B
EOF
done

chmod 600 /root/.ssh/*
chmod 700 /home/student/.ssh
chmod 600 /home/student/.ssh/*
chown student:student /home/student/.ssh -R

# Add YAML style indent for VIM to student .vimrc
echo "autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab" >> /home/student/.vimrc

cat << 'EOF' >/root/tower-inventory
[tower]
localhost ansible_connection=local
EOF

cat <<'EOF' >/root/tower-install-inventory
[tower]
localhost ansible_connection=local

[database]

[all:vars]
admin_password='RHforum20Pass'

pg_host=''
pg_port=''

pg_database='awx'
pg_username='awx'
pg_password='password'
EOF

PUBLIC_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

cat << 'EOF' >/root/tower-install.yml
- name: Install Ansible Tower
  hosts: all
  tasks:
    - name: Make sure we have a 'wheel' group
      group:
        name: wheel
        state: present

    - name: Create student user
      user:
          name: "student"
          group: wheel
          state: present
          
    - name: Set passwords for users
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^PasswordAuthentication no'
        line: 'PasswordAuthentication yes'

    - name: Allow 'wheel' group to have passwordless sudo
      lineinfile:
        dest: /etc/sudoers
        state: present
        regexp: '^%wheel'
        line: '%wheel ALL=(ALL) NOPASSWD: ALL'
        validate: visudo -cf %s

    - name: Restart service sshd, in all cases
      service:
        name: sshd
        state: restarted
  
    - name: Enable EPEL yum repo
      yum:
        name: http://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
        state: present

    - name: Install Python Pip
      yum:
        name: python2-pip
        state: present

    - name: Check if Ansible Lint is installed
      stat:
        path: /bin/ansible-lint
      register: ansible_lint

    - name: Install Ansible Lint
      pip:
        name: ansible-lint
        state: present
      when: ansible_lint.stat.exists == False

    - name: Ensure /opt/tower is created
      file:
        path: /opt/tower
        state: directory

    - name: Unzip the latest tower software
      unarchive:
        src: "https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz"
        dest: /opt/tower
        remote_src: yes

    - name: Find installer absolute path
      shell: "ls /opt/tower/ansible-tower-setup-*/setup.sh"
      register: tower_installer_path

    - name: Find base path for installer
      shell: "find /opt/tower/ansible-tower-setup* -maxdepth 0 -type d"
      register: tower_base_path

    - name: Find inventory absolute path
      shell: "ls /opt/tower/ansible-tower-setup-*/inventory"
      register: tower_inventory_path

    - name: Print installer path
      debug:
         msg: "setup path: {{ tower_installer_path.stdout }}"

    - name: Inventory path
      debug:
        msg: "inventory path: {{ tower_inventory_path.stdout }}"

    - name: Base path
      debug:
        msg: "Base path: {{ tower_base_path.stdout }}"

    - name: Copy tower install inventory into place
      copy:
        src: /root/tower-install-inventory
        dest: "{{ tower_inventory_path.stdout }}"
        force: yes

    - name: Run Ansible Tower installer
      shell: "{{tower_installer_path.stdout}} -i {{tower_inventory_path.stdout}}"

    - name: Check if Tower CLI is installed
      stat:
        path: /bin/tower-cli
      register: tower_cli

    - name: Install Tower CLI
      pip:
        name: ansible-tower-cli
        state: present
      when: tower_cli.stat.exists == False
      
    - name: Disable SSL verification
      lineinfile:
        path: /etc/tower/settings.py
        state: present
        regexp: '.*GIT_SSL_NO_VERIFY.*'
        line: AWX_TASK_ENV['GIT_SSL_NO_VERIFY'] = 'True'
      
    - name: Restart Ansible Tower
      shell: ansible-tower-service restart
      
    - name: Git, disable SSL certificate checking. Don't do this in production.
      become_user: "{{ item }}"
      become: yes
      command: git config --global http.sslVerify "false"
      with_items:
        - student
        - root
EOF

cat << 'EOF' >/etc/motd

Welcome to the Ansible lab. This is the Ansible Tower server, from this system you will do all the labs.

EOF

# Install Ansible tower
ansible-playbook -i /root/tower-inventory /root/tower-install.yml
