#!/bin/bash
# Magnus Glantz, sudo@redhat.com, 2018
# Script which sets up automatics to set a route 53 domain name (A record) based on EC2 instance tag
# which get's pointed to your ec2 instances public ip.
#
# To create the A record, then run the 'update-route53-dns' command
#

# Needs to be configured below
# Set to AWS access key. Account needs to have write access to route 53 and read access for ec2
AWS_ACCESS_KEY_ID=

# Set to AWS secret key
AWS_SECRET_ACCESS_KEY=

# Set to Route 53 Zone ID
ZONE=

# EC2 instance tag to look at
EC2TAG=identity

yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install python2-pip wget bind-utils
pip install awscli
wget https://github.com/barnybug/cli53/releases/download/0.8.12/cli53-linux-amd64

mv cli53-linux-amd64 /usr/local/bin/cli53
chmod +x /usr/local/bin/cli53
mkdir /etc/route53
chmod 700 /etc/route53
touch /etc/route53/config
chmod 600 /etc/route53/config

echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" >/etc/route53/config
echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >>/etc/route53/config
echo "ZONE=$ZONE" >>/etc/route53/config
echo "EC2TAG=$EC2TAG" >>/etc/route53/config

mkdir /root/.aws
chmod 700 /root/.aws

cat << 'EOF' >/root/.aws/config 
[default]
region = eu-central-1
EOF

echo "[default]" >/root/.aws/credentials
echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >>/root/.aws/credentials
echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >>/root/.aws/credentials

cat << 'EOF' >/usr/sbin/update-route53-dns
#!/bin/bash

# Load configuration and export access key ID and secret for cli53 and aws cli
. /etc/route53/config
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

# The TimeToLive in seconds we use for the DNS records
TTL="300"

# Get the private and public hostname from EC2 resource tags
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# Get the local and public IP Address that is assigned to the instance
PUBLIC_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Fetch tag
PUBLIC_HOSTNAME=$(aws ec2 describe-instances --instance-id $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --query 'Reservations[*].Instances[*].[ImageId,Tags[*]]'|grep $EC2TAG -B1|head -1|awk -F\" '{ print $4 }')

if [ "$PUBLIC_HOSTNAME" == "" ]; then
	echo "Failed to fetch tags."
else
	# Create a new or update the A-Records on Route53 with public and private IP address
	cli53 rrcreate --replace "$ZONE" "$PUBLIC_HOSTNAME $TTL A $PUBLIC_IPV4"
fi
EOF

chmod +rx /usr/sbin/update-route53-dns
