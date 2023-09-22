#!/bin/bash

source constants.sh

# Create the instance.
gcloud sql instances create $INSTANCE_NAME \
  --project $PROJECT_ID \
  --region $REGION \
  --database-version $DATABASE_VERSION \
  --cpu $CPU \
  --memory $MEMORY \
  --root-password $ROOT_PASSWORD

# Print the instance information.
gcloud sql instances describe $INSTANCE_NAME

# Create database
gcloud sql databases create test_cli --instance=$INSTANCE_NAME

# Create a bucket in a specific region
gcloud storage buckets create $BUCKET_NAME --location=$REGION

# Upload file from local machine
gcloud storage cp $ASSET $BUCKET_NAME

# Execute a SQL query that is on Cloud Storage
gcloud sql import sql $INSTANCE_NAME $BUCKET_NAME/$FILENAME --database=test_cli

# Delete the MySQL instance
gcloud sql instances delete $INSTANCE_NAME

# Delete the bucket
gcloud storage rm $BUCKET_NAME --recursive
