#!/bin/bash

echo "Enter in your aws credentials and default region:"

aws configure

if [ "$?" -eq 0 ]; then
  echo "Error running aws configure, please troubleshoot"
  exit 1
fi

read -p "Please enter the number of servers you like to provision: " NODECOUNT

aws ec2 create-vpc --cidr-block 10.0.0.0/16 >vpc.output 2>&1

VPCID=$(grep VpcId vpc.output|awk '{ print $2 }'|sed -e 's/"//g' -e 's/,//g')

aws ec2 create-subnet --vpc-id $VPCID --cidr-block 10.0.1.0/24 >subnet.output 2>&1

aws ec2 create-security-group --group-name AnsibleSecurityGroup --description "Ansible Security Group" --vpc-id $VPCID >group.output 2>&1

GROUPID=$(grep GroupId group.output|awk '{ print $2 }'|sed -e 's/"//g' -e 's/,//g')

aws ec2 authorize-security-group-ingress --group-id $GROUPID  --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $GROUPID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $GROUPID --protocol tcp --port 443 --cidr 0.0.0.0/0

SUBNETID=$(grep SubnetId subnet.output|awk '{ print $2 }'|sed -e 's/"//g' -e 's/,//g')

aws ec2 run-instances --image-id ami-194cdc76 --associate-public-ip-address --count $NODECOUNT --instance-type t2.micro --key-name redhat-roadshow --subnet-id $SUBNETID --tag-specifications 'ResourceType=instance,Tags=[{Key=identity,Value=system}]' --security-group-ids $GROUPID --user-data file://basic-setup.sh
