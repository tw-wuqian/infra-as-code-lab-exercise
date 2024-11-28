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
            DETAILS=$(aws ec2 describe-nat-gateways --region ${4} --filter "Name=state,Values=available" | jq '.NatGateways[] | "\(if .Tags | length > 0 then .Tags[]? | select(.Key == "Name" or (.Key | endswith("ame"))) | ("Name: " + .Value + ",") else "Name: -, " end ) \("Id: " + .NatGatewayId + ",") \("CreateTime: " + .CreateTime + "!!")"')
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
        elif [[ $3 == "ECSTD" ]]; then
            DETAILS=$(aws ecs list-task-definitions --region ${4} | jq '.taskDefinitionArns[] | ("Task Definition: " + . + "!!")')            
        elif [[ $3 == "IAM_ROLES" ]]; then
            DETAILS=$(aws iam list-roles --query "Roles[*].RoleName" | jq  '.[] | select(all(.; contains("AWS") | not)) | select(all(.; contains("OrganizationAccountAccessRole") | not))')
        elif [[ $3 == "IAM_POLICIES" ]]; then
            DETAILS=$(aws iam list-policies --query "Policies[*].PolicyName" --scope Local | jq '.[] | "\( . + "!!")"')                        
        elif [[ $3 == "LAMBDA" ]]; then
            DETAILS=$(aws lambda list-functions --region ${4} | jq '.Functions[] | "\("Name: " + .FunctionName + ",") \("Last Modified: " + .LastModified + "!!")"')            
        elif [[ $3 == "API_GATEWAYS" ]]; then
            DETAILS=$(aws apigateway get-rest-apis --region ${4} | jq '.items[] | "\("Name: " + .name + ",") \("CreateTime: " + .createdDate + "!!")"')            
        fi


        if [[ $3 != "IAM_ROLES" ]]; then
            DETAILS=$(echo $DETAILS | sed 's/!!/\n\t\t/g' | sed 's/"//g' | tail -r | tail -n +2 | tail -r)
        fi
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


    ### ECS Task Definitions

    ECSTD=$(aws ecs list-task-definitions --region ${REGION} | jq '.taskDefinitionArns | length')     
    _resource_check "ECS Task Definitions" $ECSTD "YELLOW"
    _retrieve_more_details $ECSTD "YELLOW" "ECSTD" ${REGION}


    ### NAT Gateways

    NAT_GATEWAYS=$(aws ec2 describe-nat-gateways --region ${REGION} --filter "Name=state,Values=available" | jq '.NatGateways | length')
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
    _resource_check "Load Balancers" $ALBS "YELLOW"
    _retrieve_more_details $ALBS "YELLOW" "ALB" ${REGION}


    ### Cloudformation Stacks

    CFN=$(aws cloudformation describe-stacks --region ${REGION} | jq '.Stacks | length')     
    _resource_check "Cloudformation Stacks" $CFN "YELLOW"
    _retrieve_more_details $CFN "YELLOW" "CFN" ${REGION}


    ### EIPs

    EIPS=$(aws ec2 describe-addresses --region ${REGION} | jq '.Addresses | length')     
    _resource_check "Elastic IPs" $EIPS "YELLOW"
    _retrieve_more_details $EIPS "YELLOW" "EIPS" ${REGION}


    ### Lambda

    LAMBDA=$(aws lambda list-functions --region ${REGION} | jq '.Functions | length')     
    _resource_check "Lambda Functions" $LAMBDA "YELLOW"
    _retrieve_more_details $LAMBDA "YELLOW" "LAMBDA" ${REGION}


    ### API Gateways

    API_GATEWAYS=$(aws apigateway get-rest-apis --region ${REGION} | jq '.items | length')     
    _resource_check "API Gateways" $API_GATEWAYS "YELLOW"
    _retrieve_more_details $API_GATEWAYS "YELLOW" "API_GATEWAYS" ${REGION}


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


# S3 Buckets

echo "\n\n"
S3=$(aws s3api list-buckets | jq '.Buckets | length' )
_resource_check "S3" $S3 "YELLOW"
_retrieve_more_details $S3 "YELLOW" "S3" ${REGION}


# IAM Policies

echo "\n"
IAM_POLICIES=$(aws iam list-policies --query "Policies[*].PolicyName" --scope Local | jq '. | length')
_resource_check "IAM Policies" $IAM_POLICIES "YELLOW"
_retrieve_more_details $IAM_POLICIES "YELLOW" "IAM_POLICIES" ${REGION}


# IAM Roles

echo "\n"
IAM_ROLES=$(aws iam list-roles --query "Roles[*].RoleName" | jq  '.[] | select(all(.; contains("AWS") | not)) | select(all(.; contains("OrganizationAccountAccessRole") | not))' | wc -l | sed 's/ //g')
_resource_check "IAM Roles" $IAM_ROLES "YELLOW"
_retrieve_more_details $IAM_ROLES "YELLOW" "IAM_ROLES" ${REGION}


echo "\n${GREEN}Helpful hint:${NC} If resource IDs and tags aren't helpful to identify who created the resources, you can use CloudTrail and search on the 'Resource Name' with the value of the resource Id which may help to identify who created the resources."
echo "${GREEN}Expectations:${NC} In theory, assuming no other training courses are using this AWS account, all resources should be at 0 (maybe the odd AWS Config S3 bucket might need to remain).\n"