#!/bin/bash

source constants.sh

# Activate API's
gcloud services enable dataproc.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable bigquery.googleapis.com

# Generate test data and upload to the bucket
python generate_data.py
gcloud storage buckets create $BUCKET_NAME --location=$REGION
gcloud storage cp $FILENAME $BUCKET_NAME

# Create a folder on Cloud Storage for the Hive table
gsutil cp - $BUCKET_NAME/hive_tables/purchase_history <<< "" 

# Create a Dataproc cluster and submit the job
gcloud dataproc clusters create $CLUSTER_NAME \
    --region=$REGION \
    --zone=$ZONE \
    --num-masters=1 \
    --num-workers=0 \
    --master-machine-type=n2-standard-2 \
    --service-account=$SERVICE_ACCOUNT

gcloud dataproc jobs submit pyspark \
    --cluster=$CLUSTER_NAME \
    --region=$REGION \
    create_hive_table.py

# Create a dataset and a table on BigQuery
bq mk --dataset \
      --location=$REGION \
      $PROJECT_ID:$DATASET_NAME

bq mk --table \
      --location=$REGION \
      --schema schema.json $PROJECT_ID:$DATASET_ID.$TABLE_NAME

# Load data from the Hive table to BigQuery
bq load \
    --source_format=PARQUET \
    --replace=true \
    --autodetect \
    --hive_partitioning_source_uri_prefix=$BUCKET_NAME/hive_tables/purchase_history/ \
    $DATASET_ID.$TABLE_NAME $BUCKET_NAME/hive_tables/purchase_history/part-*

# Query the data on BigQuery
bq query --location=$REGION --use_legacy_sql=false \
    "SELECT * FROM $DATASET_ID.$TABLE_NAME LIMIT 10"


## CLEANUP

# 1. Delete a bucket with all its content
gcloud storage rm $BUCKET_NAME --recursive

# 2. Delete the table
bq rm --table=true --force=true $DATASET_ID.$TABLE_NAME

# 3. Delete the dataset
bq rm --dataset=true --force=true $DATASET_ID

# 4. Stop the dataproc cluster
gcloud dataproc clusters stop $CLUSTER_NAME --region=$REGION

# 5. Delete the dataproc cluster
gcloud dataproc clusters delete $CLUSTER_NAME --region=$REGION

# 6. Deactivate the API's
gcloud services disable dataproc.googleapis.com
gcloud services disable storage.googleapis.com
gcloud services disable bigquery.googleapis.com --force
