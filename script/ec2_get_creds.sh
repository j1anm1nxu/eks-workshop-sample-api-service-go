#!/usr/bin/env bash
#
# Note that k8s nodes have name and tags in lower case
#
# For k8s nodes:
#   ec2_get_creds.sh major minor service
# For infra instances:
#   ec2_get_creds.sh Major Minor Service
#
# export AWS_INST_ID=$(ec2metadata --instance-id)
# export AWS_MAJOR=`aws ec2 describe-tags --filters "Name=resource-id,Values=$AWS_INST_ID" "Name=key,Values=$1" | jq '.Tags[0].Value' | sed "s/\"//g"`
# export AWS_MINOR=`aws ec2 describe-tags --filters "Name=resource-id,Values=$AWS_INST_ID" "Name=key,Values=$2" | jq '.Tags[0].Value' | sed "s/\"//g"`
# export AWS_SERVICE=`aws ec2 describe-tags --filters "Name=resource-id,Values=$AWS_INST_ID" "Name=key,Values=$3" | jq '.Tags[0].Value' | sed "s/\"//g"`
# 
# echo "This EC2 instance ${AWS_INST_ID} is part of the service ${AWS_MAJOR}-${AWS_MAJOR}-${AWS_SERVICE}"
#
export AWS_INST_PROFILE=$(curl http://169.254.169.254/latest/meta-data/iam/security-credentials)
export CREDS=$(curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${AWS_INST_PROFILE}) 
#
export AWS_ACCESS_KEY_ID=`echo ${CREDS} | jq -r '.AccessKeyId'`
export AWS_SECRET_ACCESS_KEY=`echo ${CREDS} | jq -r '.SecretAccessKey'`
export AWS_SESSION_TOKEN=`echo ${CREDS} | jq -r '.Token'`
#
export AWS_DEFAULT_REGION=`ec2metadata --availability-zone | sed 's/.$//'`
#
export AWS_ACCOUNT_ID=`aws sts get-caller-identity | jq -r '.Account'`
#
echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"
echo "export AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}"
echo "export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}"
echo "export AWS_ACCOUNT_ID=${AWS_ACCOUNT_ID}"
#
export AWS_INST_ID=$(ec2metadata --instance-id)
#
export HOME_PATH=/root
cd $HOME_PATH
mkdir -p .aws
cd .aws
cat << EOF > credentials
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
aws_session_token=${AWS_SESSION_TOKEN}
region=${AWS_DEFAULT_REGION}
output=json
EOF
#
# export HOME_PATH=/home/ec2-user
export HOME_PATH=/home/ubuntu
cd $HOME_PATH
mkdir -p .aws
cd .aws
cat << EOF > credentials
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
aws_session_token=${AWS_SESSION_TOKEN}
region=${AWS_DEFAULT_REGION}
output=json
EOF
chown -R ubuntu:ubuntu credentials
#
export AWS_MAJOR=`aws ec2 describe-tags --filters "Name=resource-id,Values=$AWS_INST_ID" "Name=key,Values=$1" | jq '.Tags[0].Value' | sed "s/\"//g"`
export AWS_MINOR=`aws ec2 describe-tags --filters "Name=resource-id,Values=$AWS_INST_ID" "Name=key,Values=$2" | jq '.Tags[0].Value' | sed "s/\"//g"`
export AWS_SERVICE=`aws ec2 describe-tags --filters "Name=resource-id,Values=$AWS_INST_ID" "Name=key,Values=$3" | jq '.Tags[0].Value' | sed "s/\"//g"`
#
echo "This EC2 instance ${AWS_INST_ID} is part of the service ${AWS_MAJOR}-${AWS_MINOR}-${AWS_SERVICE}"
#