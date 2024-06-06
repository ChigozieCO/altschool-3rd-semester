#!/bin/bash

# Variables
VPC_ID="vpc-068839ae9a3a4b06f" # Replace with your VPC ID

# Arrays for subnet configurations
CIDR_BLOCKS=("10.0.0.0/24" "10.0.1.0/24" "10.0.2.0/24" "10.0.3.0/24")
AVAILABILITY_ZONES=("us-east-1a" "us-east-1b" "us-east-1c" "us-east-1d")
NAMES=("pb-subnet-1" "pb-subnet-2" "pv-subnet-1" "pv-subnet-2")

# Create subnets
for i in {0..3}; do
    aws ec2 create-subnet \
        --vpc-id $VPC_ID \
        --cidr-block ${CIDR_BLOCKS[$i]} \
        --availability-zone ${AVAILABILITY_ZONES[$i]} \
        --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${NAMES[$i]}}]"

    echo "Created subnet ${NAMES[$i]} with CIDR block ${CIDR_BLOCKS[$i]} in ${AVAILABILITY_ZONES[$i]}"
done