#!/bin/bash

source constanst.sh

gcloud services enable dataflow.googleapis.com
gcloud services enable storage.googleapis.com

# Create a bucket
gcloud storage buckets create $BUCKET_NAME --location $REGION

# Upload book to the bucket
gcloud storage cp book.txt $BUCKET_NAME

# Execute the Dataflow job
python -m \
    apache_beam.examples.wordcount \
    --region $REGION \
    --input $BUCKET_NAME/book.txt \
    --output $BUCKET_NAME/output/ \
    --runner DataflowRunner \
    --project $PROJECT_ID \
    --temp_location $BUCKET_NAME/temp/ \
    --service_account $SERVICE_ACCOUNT

## CLEANUP
gcloud services disable dataflow.googleapis.com
gcloud services disable storage.googleapis.com
