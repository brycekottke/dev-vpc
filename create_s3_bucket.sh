#!/bin/bash
#
# Author:
#   - Bryce Kottke 
# Description: 
#   - This script will create an S3 Bucket to hold all the Terraform .tfstate files.
# Use Case:
#   - Set your profile up in ~/.aws/credentials
#   - Modify the 's3_bucket' and 'profile' variables below to your liking
# TODO:
#   - re-write to use the 'case' feature in bash script. This way we can call 's3_bucket'
#     and 'profile' directly like so. "./create_s3_bucket.sh -p profile -b bucketname"
#

## Variables
s3_bucket='mycompany-builds'
profile='mycompany-dev'

## Check if S3 Bucket exists. If not, Create it
aws --profile ${profile} s3api list-buckets |grep "${s3_bucket}" > /dev/null

if [ "$?" -eq "0" ]; then
  echo "AWS Bucket '${s3_bucket}' Already Exists. "
else
  aws s3api --profile ${profile} create-bucket --bucket ${s3_bucket} --region us-east-1
  echo "Created '${s3_bucket} Bucket. "
fi
