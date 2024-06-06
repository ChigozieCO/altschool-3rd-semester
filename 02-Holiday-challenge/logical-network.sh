# Command to check the available VPCs in your defaukt region

aws ec2 describe-vpcs --query "Vpcs[].VpcId"

# Command to create a VPC

aws ec2 create-vpc \
    --cidr-block 10.0.0.0/16 \
    --region us-east-1 \
    --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=HC-vpc}]'


# Command to create a subnet

aws ec2 create-subnet \
    --vpc-id <your vpc id> \
    --cidr-block 10.0.0.0/24 \
    --availability-zone <your availabilty zones> \
    --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=HC-vpc}]'

# Command to check the subnets a particular VPC has

aws ec2 describe-subnets --query "Subnets[].Tags" --output text

# Command to create an internet gateway

aws ec2 create-internet-gateway \
    --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=HC-IGW}]'