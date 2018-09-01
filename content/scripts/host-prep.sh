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

chmod 600 /home/student/.ssh/*
chown student:student /home/student/.ssh -R

mkdir /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/*

cat << 'EOF' >/etc/motd

Welcome to the Ansible lab. This is system managed by the Ansible Tower server, normally you do not need to be here.

EOF
	
