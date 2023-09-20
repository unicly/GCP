#!/bin/bash

source constants.sh

# Create a bucket in a specific region
gcloud storage buckets create $BUCKET_NAME --location=$REGION

# Change lifecycle configuration for a bucket
gcloud storage buckets update $BUCKET_NAME --lifecycle-file=./lifecycle_mngmt_config.json

# Upload file from local machine
gcloud storage cp $ASSET $BUCKET_NAME

# List the content in the bucket
gcloud storage ls $BUCKET_NAME

# Show the metadata associated with the asset
gcloud storage objects describe $BUCKET_NAME/$FILENAME

# Change storage class to Nearline for a bucket
gcloud storage buckets update $BUCKET_NAME --default-storage-class=nearline

# Change IAM policy
gcloud storage buckets get-iam-policy $BUCKET_NAME > iam_policy.txt
gcloud storage buckets set-iam-policy $BUCKET_NAME iam_policy.txt

# Rename an object
gcloud storage mv $BUCKET_NAME/$FILENAME $BUCKET_NAME/renamed.png

# Delete an object
gcloud storage rm $BUCKET_NAME/renamed.png

# Show the events logs of the bucket
gcloud logging read $BUCKET_NAME_CLEAN

# Delete a bucket with all its content
gcloud storage rm $BUCKET_NAME --recursive