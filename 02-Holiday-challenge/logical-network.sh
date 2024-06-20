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


# Command to attach the Internet Gateway to the VPC
aws ec2 attach-internet-gateway \
    --internet-gateway-id igw-xxxxxxxxxxx # Replace with your IGW ID \
    --vpc-id vpc-xxxxxxxxxxxx # Replace with your VPC ID


# Command to confirm the attachment of the IGW to a VPC
aws ec2 describe-internet-gateway \
    --internet-gateway-id "igw-xxxxxxxxxxxxx" # Replace with your IGW ID


# Command to retrieve the main route table ID
aws ec2 describe-route-tables \
    --filters "Name=vpc-id,Values=<VPC_ID>" \
    "Name=association.main,Values=true" \
	  --query "RouteTables[].RouteTableId"


# Command to add a tag to name the main route table
aws ec2 create-tags \
    --resources rtb-xxxxxxxxxx \
    --tags Key=Name,Value="HC-public-RT"


# Command to retrieve the subnetIds
aws ec2 describe-subnets \
    --filter "Name=vpc-id,Values=vpc-xxxxxxxxxxxx" \
    --query "Subnets[].[Tags, SubnetId]" \
    --output yaml

# Command to edit subnet association
aws ec2 associate-route-table \
	--route-table-id rtb-049b029f560218788 \
	--subnet-id <subnetid of pb-subnet-1> # One subnet at a time