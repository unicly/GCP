#!/bin/bash

source constants.sh

# 1. Activate BigQuery API
gcloud services enable bigquery.googleapis.com

# 2. Create a Google Storage bucket for the data files
gcloud storage buckets create $BUCKET_NAME --location=$REGION

# 4. Create a dataset
bq mk --dataset --location=$REGION --project_id=$PROJECT_ID --dataset_id=$DATASET_ID

# 5. Create a table
bq mk --table --description="Active clients" --schema=./schema.json $PROJECT_ID:$DATASET_ID.$TABLE_NAME

# 6. Show the table schema
bq show --format=prettyjson $PROJECT_ID:$DATASET_ID.$TABLE_NAME

# 7. Upload the data files on Google Storage
gcloud storage cp ./clients_1.csv $BUCKET_NAME
gcloud storage cp ./clients_2.csv $BUCKET_NAME

# 8. Import the data from the first file to the table
# ./schema.json - The schema file can't be used if on Google Storage. It must be local.
# --replace=false - The data is going to be appended to the table.
bq load \
--location=$REGION \
--source_format=CSV \
--skip_leading_rows=1 \
--replace=false \
$DATASET_ID.$TABLE_NAME \
$BUCKET_NAME/clients_1.csv \
./schema.json

# 9. Check the result from the import
bq query --location=$REGION --use_legacy_sql=false \
"SELECT * FROM $DATASET_ID.$TABLE_NAME"

# 10. Import the data from the second file to the table
bq load \
--location=$REGION \
--source_format=CSV \
--skip_leading_rows=1 \
--replace=false \
$DATASET_ID.$TABLE_NAME \
$BUCKET_NAME/clients_2.csv \
./schema.json

# 10. Check the result from the import
bq query --location=$REGION --use_legacy_sql=false \
"SELECT * FROM $DATASET_ID.$TABLE_NAME"

# 11. Delet the bucket together with its content
gcloud storage rm $BUCKET_NAME --recursive

# 12. Delete the table
bq rm --table=true --force=true $DATASET_ID.$TABLE_NAME

# 13. Delete the dataset
bq rm --dataset=true --force=true $DATASET_ID

# 13. Deactivate the BigQuery API
gcloud services disable bigquery.googleapis.com --force
