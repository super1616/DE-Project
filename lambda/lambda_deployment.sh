#!/bin/bash

# YouTube Data Ingestion Lambda Deployment Script

set -e

echo "Starting Lambda deployment..."

# Variables
FUNCTION_NAME="YouTubeDataIngestion"
ROLE_NAME="YouTubeDataIngestionLambdaRole"
S3_BUCKET="youtube-lambda-code"
AWS_REGION="us-east-1"

# Create IAM Role

echo "Creating IAM role..."
aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document '{"Version": "2012-10-17", "Statement": [{"Effect": "Allow", "Principal": {"Service": "lambda.amazonaws.com"}, "Action": "sts:AssumeRole"}]}' || echo "Role already exists"

# Attach policies
echo "Attaching policies..."
aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess

aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess

# Wait for role to be available
sleep 10

# Create S3 bucket for Lambda code
echo "Creating S3 bucket for Lambda code..."
aws s3 mb s3://$S3_BUCKET --region $AWS_REGION || echo "Bucket already exists"

# Package Lambda function
echo "Packaging Lambda function..."
cd lambda/data_ingestion
zip -r function.zip . -x "*.git*"
aws s3 cp function.zip s3://$S3_BUCKET/

# Create Lambda function
echo "Creating Lambda function..."
ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text)

aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --runtime python3.9 \
    --role $ROLE_ARN \
    --handler lambda_function.lambda_handler \
    --code S3Bucket=$S3_BUCKET,S3Key=function.zip \
    --timeout 300 \
    --memory-size 512 \
    --environment Variables="{YOUTUBE_API_KEY=$YOUTUBE_API_KEY,S3_BUCKET_RAW=$S3_BUCKET_RAW}" \
    --region $AWS_REGION || echo "Function already exists"

# Create CloudWatch Events trigger
echo "Creating CloudWatch Events trigger..."
aws events put-rule \
    --name YouTubeDataIngestionSchedule \
    --schedule-expression "cron(0 0 * * ? *)" \
    --region $AWS_REGION

aws events put-targets \
    --rule YouTubeDataIngestionSchedule \
    --targets "Id"="1","Arn"="$(aws lambda get-function --function-name $FUNCTION_NAME --query 'Configuration.FunctionArn' --output text)" \
    --region $AWS_REGION

aws lambda add-permission \
    --function-name $FUNCTION_NAME \
    --statement-id YouTubeDataIngestionSchedule \
    --action lambda:InvokeFunction \
    --principal events.amazonaws.com \
    --source-arn $(aws events describe-rule --name YouTubeDataIngestionSchedule --query 'Arn' --output text) \
    --region $AWS_REGION || echo "Permission already exists"

echo "Lambda deployment completed successfully!"
