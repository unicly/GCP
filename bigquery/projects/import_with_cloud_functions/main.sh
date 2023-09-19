#!/bin/bash

source constants_my.sh

# 1. Activate BigQuery and Cloud Functions API
gcloud services enable bigquery.googleapis.com
gcloud services enable cloudfunctions.googleapis.com

# 2. Create a Google Storage bucket for the data files
gcloud storage buckets create $BUCKET_NAME --location=$REGION --project=$PROJECT_ID

# 4. Create a dataset
bq mk --dataset --location=$REGION --project_id=$PROJECT_ID --dataset_id=$DATASET_ID

# 5. Create a table
bq mk --table --description="Active clients" --schema=./schema.json $PROJECT_ID:$DATASET_ID.$TABLE_NAME

# 6. Show the table schema
bq show --format=prettyjson $PROJECT_ID:$DATASET_ID.$TABLE_NAME

# 7. Zip the source files and upload them to Google Storage
# A cloud function needs to have main.py in order to work
zip -r ./sources.zip main.py config.json requirements.txt
gcloud storage cp ./sources.zip $BUCKET_NAME

# 8. Deploy the function to Cloud Functions
gcloud functions deploy import_csv_to_bigquery \
--no-gen2 \
--region=$REGION \
--project=$PROJECT_ID \
--runtime=python39 \
--service-account=$SERVICE_ACCOUNT \
--source=$BUCKET_NAME/sources.zip \
--trigger-resource=$BUCKET_NAME \
--trigger-event=google.storage.object.finalize \
--docker-registry=artifact-registry

# 7. Upload the data files on Google Storage
gcloud storage cp ./clients_1.csv $BUCKET_NAME
gcloud storage mv $BUCKET_NAME/clients_1.csv $BUCKET_NAME/clients.csv

# 8. Check the result from the import
bq query --location=$REGION --use_legacy_sql=false \
"SELECT * FROM $DATASET_ID.$TABLE_NAME"

# 7. Upload the data files on Google Storage
gcloud storage cp ./clients_2.csv $BUCKET_NAME
gcloud storage mv $BUCKET_NAME/clients_2.csv $BUCKET_NAME/clients.csv

# 9. Check the result from the import
bq query --location=$REGION --use_legacy_sql=false \
"SELECT * FROM $DATASET_ID.$TABLE_NAME"

# 10. Delet the bucket together with its content
gcloud storage rm $BUCKET_NAME --recursive

# 11. Delete the table
bq rm --table=true --force=true $DATASET_ID.$TABLE_NAME

# 12. Delete the dataset
bq rm --dataset=true --force=true $DATASET_ID

# 13. Delete de function on Google Functions
gcloud functions delete import_csv_to_bigquery --region=$REGION

# 14. Deactivate the BigQuery API
gcloud services disable bigquery.googleapis.com --force
gcloud services disable cloudfunctions.googleapis.com --force
