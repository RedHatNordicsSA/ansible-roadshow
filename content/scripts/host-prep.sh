#!/bin/bash
# Magnus Glantz, sudo@redhat.com, 2018
# Prep hosts to be managed by Tower

yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
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
    yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    rpm -q epel-release
    if [ "$?" -eq 0 ]; then
      echo "EPEL installed, going forward with install."
      break
    else
      ITER=$(expr $ITER + 1)
    fi
  fi
done

yum -y install python2-pip wget bind-utils ansible nano vim screen emacs joe
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
    yum -y install python2-pip wget bind-utils ansible nano vim screen emacs joe
    rpm -q ansible
    if [ "$?" -eq 0 ]; then
      echo "Ansible installed, going forward with install."
      break
    else
      ITER=$(expr $ITER + 1)
    fi
  fi
done

# Create directory for ssh public key
if [ ! -d /root/.ssh ]; then
  mkdir /root/.ssh
  chmod 600 /root/.ssh
fi

useradd student
echo "RHforum18Pass" | passwd student --stdin
usermod -aG wheel student
# I know I shouldn't edit the /etc/sudoers file with any sort of script. There's a reason for the visudo command.
# That being said...
sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
mkdir /home/student/.ssh
chmod 700 /home/student/.ssh
curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa >/home/student/.ssh/id_rsa
curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa.pub >/home/student/.ssh/authorized_keys
chmod 600 /home/student/.ssh/*
chown student:student /home/student/.ssh -R

mkdir /root/.ssh
chmod 700 /root/.ssh
curl https://raw.githubusercontent.com/mglantz/ansible-roadshow/master/content/id_rsa.pub >/root/.ssh/authorized_keys
chmod 600 /root/.ssh/*

cat << 'EOF' >/etc/motd

Welcome to the Ansible lab. This is system managed by the Ansible Tower server, normally you do not need to be here.

EOF
	
