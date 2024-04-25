############################################################################################
#
# Title: AWS Resource Query Script
# Purpose: This script is designed to provide transparency about which AWS
# resources have not been cleaned up during and after a training course
#
# Usage: authenticate aith AWS then run this script ./query_aws_resources 
# You can also pass in a region just to query a single region
# For example: ./query_aws_resources us-east-2
# You may need to add executable permissions locally to the file first 
# For example: chomd +x ./query_aws_resources
#
############################################################################################

# Colour
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Colour

function _resource_check {
    if [[ $2 -gt 0 ]]
    then
    if [[ $3 == "RED" ]]
    then
    echo "\t${RED}${1}: ${2}${NC}"
    else
    echo "\t${YELLOW}${1}: ${2}${NC}"
    fi
    else
    echo "\t${GREEN}${1}: ${2}${NC}"
    fi
}

function _retrieve_more_details {

    if [[ $1 -gt 0 ]]; then

        if [[ $3 == "EC2" ]]; then
            DETAILS=$(aws ec2 describe-instances --region ${4} | jq '.Reservations[].Instances[] | "\(if .Tags | length > 0 then .Tags[]? | select(.Key == "Name") | ("Name: " + .Value + ",") else "Name: -, " end ) \("Id: " + .InstanceId + ",") \("Status: " + .State.Name + ",") \("LaunchTime: " + .LaunchTime + "!!")"')
        elif [[ $3 == "RDS" ]]; then
            DETAILS=$(aws rds describe-db-instances --region ${4} | jq '.DBInstances[] | "\("DatabaseId: " + .DBInstanceIdentifier + ",") \("CreateTime: " + .InstanceCreateTime + "!!")"')
        elif [[ $3 == "ECS" ]]; then
            DETAILS=$(aws ecs list-clusters --region ${4} | jq '.clusterArns[] | ("ARN: " + . + "!!")')
        elif [[ $3 == "NAT" ]]; then
            DETAILS=$(aws ec2 describe-nat-gateways --region ${4} | jq '.NatGateways[] | "\(if .Tags | length > 0 then .Tags[]? | select(.Key == "Name" or (.Key | endswith("ame"))) | ("Name: " + .Value + ",") else "Name: -, " end ) \("Id: " + .NatGatewayId + ",") \("CreateTime: " + .CreateTime + "!!")"')
        elif [[ $3 == "ALB" ]]; then
            DETAILS=$(aws elbv2 describe-load-balancers --region ${4} | jq '.LoadBalancers[] | "\("LBName: " + .LoadBalancerName + ",") \("CreateTime: " + .CreatedTime + "!!")"')
        elif [[ $3 == "VPC" ]]; then
            DETAILS=$(aws ec2 describe-vpcs --region ${4} | jq '.Vpcs[] | "\(if .Tags | length > 0 then .Tags[]? | select(.Key == "Name" or (.Key | endswith("ame"))) | ("Name: " + .Value + ",") else "Name: -, " end ) \("Id: " + .VpcId + "!!")"')          
        elif [[ $3 == "DYNAMO_DB" ]]; then
            DETAILS=$(aws dynamodb list-tables --region ${4} | jq '.TableNames[] | ("Table: " + . + "!!")')
        elif [[ $3 == "S3" ]]; then
            DETAILS=$(aws s3api list-buckets --region ${4} | jq '.Buckets[] | "\("Name: " + .Name + ",") \("CreateTime: " + .CreationDate + "!!")"')  
        elif [[ $3 == "EIPS" ]]; then
            DETAILS=$(aws ec2 describe-addresses --region ${4} | jq '.Addresses[] | "\("EIP: " + .PublicIp + "!!")"')                        
        elif [[ $3 == "CFN" ]]; then
            DETAILS=$(aws cloudformation describe-stacks --region ${4} | jq '.Stacks[] | "\("Name: " + .StackName + ",") \("CreateTime: " + .CreationTime + "!!")"')
        elif [[ $3 == "SECRETS" ]]; then
            DETAILS=$(aws secretsmanager list-secrets --region ${4} | jq '.SecretList[] | "\("Name: " + .Name + ",") \("CreateTime: " + .CreatedDate + "!!")"') 
        elif [[ $3 == "ECR" ]]; then
            DETAILS=$(aws ecr describe-repositories --region ${4} | jq '.repositories[] | "\("Name: " + .repositoryName + ",") \("CreateTime: " + .createdAt + "!!")"')                                   
        fi

        DETAILS=$(echo $DETAILS | sed 's/!!/\n\t\t/g' | sed 's/"//g' | tail -r | tail -n +2 | tail -r)
        if [[ $2 == "RED" ]]; then    
            echo "\t\t ${RED}${DETAILS}${NC}"
        else
            echo "\t\t ${YELLOW}${DETAILS}${NC}"
        fi

    fi

}

AWS_REGION_LIST=$(aws ec2 describe-regions | jq -r '.Regions[] | .RegionName')

if [[ ! -z "$1" ]]; then 
REGION_EXISTS=$(echo "${AWS_REGION_LIST}" | grep $1 | wc -w | sed 's/ //g')
if [[ $REGION_EXISTS != 1 ]]; then 
echo "${RED}Region '${1}' does not exist, please double check it is a AWS correct region.${NC}"
exit 1
fi
AWS_REGION_LIST=($1)
fi

for REGION in $AWS_REGION_LIST
do

    echo "\n${GREEN}${REGION}${NC}"
  

    ### EC2 Instances
  
    EC2_INSTANCES=$(aws ec2 describe-instances --region ${REGION} | jq '.Reservations | length')
    _resource_check "EC2 instances" $EC2_INSTANCES "RED"
    _retrieve_more_details $EC2_INSTANCES "RED" "EC2" ${REGION}


    ### RDS Instances

    RDS_INSTANCES=$(aws rds describe-db-instances --region ${REGION} | jq '.DBInstances | length') 
    _resource_check "RDS instances" $RDS_INSTANCES "RED"    
    _retrieve_more_details $RDS_INSTANCES "RED" "RDS" ${REGION}


    ### ECS Clusters

    ECS_CLUSTERS=$(aws ecs list-clusters --region ${REGION} | jq '.clusterArns | length')
    _resource_check "ECS clusters" $ECS_CLUSTERS "RED"
    _retrieve_more_details $ECS_CLUSTERS "RED" "ECS" ${REGION}


    ### ECR

    ECR=$(aws ecr describe-repositories --region ${REGION} | jq '.repositories | length')     
    _resource_check "Elastic Container Repositories" $ECR "YELLOW"
    _retrieve_more_details $ECR "YELLOW" "ECR" ${REGION}


    ### NAT Gateways

    NAT_GATEWAYS=$(aws ec2 describe-nat-gateways --region ${REGION} | jq '.NatGateways | length')
    _resource_check "NAT gateways" $NAT_GATEWAYS "YELLOW"
    _retrieve_more_details $NAT_GATEWAYS "YELLOW" "NAT" ${REGION}


    ### VPCs

    VPCS=$(aws ec2 describe-vpcs --region ${REGION} | jq '.Vpcs | length')
    _resource_check "VPCs" $VPCS "YELLOW"
    _retrieve_more_details $VPCS "YELLOW" "VPC" ${REGION}


    ### DynamoDB

    DYNAMO_DB=$(aws dynamodb list-tables --region ${REGION} | jq '.TableNames | length')
    _resource_check "DynamoDB" $DYNAMO_DB "YELLOW"
    _retrieve_more_details $DYNAMO_DB "YELLOW" "DYNAMO_DB" ${REGION}


    ### ALBs

    ALBS=$(aws elbv2 describe-load-balancers --region ${REGION} | jq '.LoadBalancers | length')     
    _resource_check "Load balancers" $ALBS "YELLOW"
    _retrieve_more_details $ALBS "YELLOW" "ALB" ${REGION}


    ### Cloudformation Stacks

    CFN=$(aws cloudformation describe-stacks --region ${REGION} | jq '.Stacks | length')     
    _resource_check "Cloudformation Stacks" $CFN "YELLOW"
    _retrieve_more_details $CFN "YELLOW" "CFN" ${REGION}


    ### EIPs

    EIPS=$(aws ec2 describe-addresses --region ${REGION} | jq '.Addresses | length')     
    _resource_check "Elastic IPs" $EIPS "YELLOW"
    _retrieve_more_details $EIPS "YELLOW" "EIPS" ${REGION}


    ### Secrets

    SECRETS=$(aws secretsmanager list-secrets --region ${REGION} | jq '.SecretList | length')     
    _resource_check "Secrets" $SECRETS "YELLOW"
    _retrieve_more_details $SECRETS "YELLOW" "SECRETS" ${REGION}

    EC2_VOLUMES=$(aws ec2 describe-volumes --region ${REGION} | jq '.Volumes | length')     
    _resource_check "EC2 volumes" $EC2_VOLUMES "YELLOW"
    
    EC2_IMAGES=$(aws ec2 describe-images --owner self --region ${REGION} | jq '.Images | length')             
    _resource_check "EC2 images" $EC2_IMAGES "YELLOW"
    
    EC2_SNAPSHOTS=$(aws ec2 describe-snapshots --owner self --region ${REGION} | jq '.Snapshots | length')     
    _resource_check "EC2 snapshots" $EC2_SNAPSHOTS "YELLOW"        

done

echo "\n\n"
S3=$(aws s3api list-buckets | jq '.Buckets | length' )
_resource_check "S3" $S3 "YELLOW"
_retrieve_more_details $S3 "YELLOW" "S3" ${REGION}


echo "\n${GREEN}Helpful hint:${NC} If resource IDs and tags aren't helpful to identify who created the resources, you can use CloudTrail and search on the 'Resource Name' with the value of the resource Id which may help to identify who created the resources."
echo "${GREEN}Expectations:${NC} In theory, assuming no other training courses are using this AWS account, all resources should be at 0.\n"