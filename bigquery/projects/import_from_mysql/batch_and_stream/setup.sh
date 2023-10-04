#!/bin/bash

source constants.sh

## API's

# 1. Activate the API's
gcloud services enable bigquery.googleapis.com
gcloud services enable cloudsql.googleapis.com
gcloud services enable appengine.googleapis.com


##  CLOUD STORAGE

# 2. Create Google Storage bucket
gcloud storage buckets create $BUCKET_NAME --location=$REGION

# 3. Upload file from local machine
gcloud storage cp $QUERIES $BUCKET_NAME
gcloud storage cp $BIGQUERY_DATA $BUCKET_NAME


## CLOUD SQL

# 4. Create a MySQL instance.
gcloud sql instances create $INSTANCE_NAME \
  --project $PROJECT_ID \
  --region $REGION \
  --database-version $DATABASE_VERSION \
  --cpu $CPU \
  --memory $MEMORY \
  --root-password $ROOT_PASSWORD

# 5. Create a databse
gcloud sql databases create users --instance=$INSTANCE_NAME

# 6. Execute a SQL query on Cloud Storage that creates a table and imports data
gcloud sql import sql $INSTANCE_NAME $BUCKET_NAME/$FILENAME --database=users


## BIGQUERY

# 7. Create a BigQuery dataset
bq mk --dataset --location=$REGION --project_id=$PROJECT_ID --dataset_id=$BIGQUERY_DATASET_ID

# 8. Use the CSV to create a new external table in the dataset
# Insert at least 1 line in the table otherwise it doesn't work
bq mk --table \
      --description="Users" \
      --schema=schema.json \
      unicly-projekt:users.user

bq load --autodetect=TRUE --source_format=CSV $BIGQUERY_DATASET_ID.$BIGQUERY_TABLE_NAME $BUCKET_NAME/$BIGQUERY_DATA_FILE


## CLOUD SCHEDULER

# 9. Create a Cloud Scheduler job
gcloud scheduler jobs create pubsub $SCHEDULER \
    --schedule="0 4 * * *" \
    --topic=$PUBSUB_TOPIC \
    --message-body="Hello" \
    --location=$REGION \
    --impersonate-service-account=$SERVICE_ACCOUNT


## PUB/SUB
gcloud pubsub topics create $PUBSUB_TOPIC


## CLOUD FUNCTIONS

# 10. Zip the source files and upload them to Google Storage
# A cloud function needs to have main.py in order to work
zip -r ./sources.zip main.py constants.json requirements.txt
gcloud storage cp ./sources.zip $BUCKET_NAME

# 11. Deploy the function to Cloud Functions
gcloud functions deploy import_data_to_bigquery \
    --no-gen2 \
    --region=$REGION \
    --project=$PROJECT_ID \
    --runtime=python39 \
    --service-account=$SERVICE_ACCOUNT \
    --source=$BUCKET_NAME/sources.zip \
    --trigger-topic=$PUBSUB_TOPIC


# 12. Execute the function Cloud Functions to export data from Cloud SQL to BigQuery
gcloud functions call $FUNCTION_NAME --region=$REGION

# 13. Test the complete flow by executing the scheduler
gcloud scheduler jobs run $SCHEDULER --location=$REGION


#CLEANUP

# 1. Delete the MySQL instance
gcloud sql instances delete $INSTANCE_NAME

# 2. Delete the bucket
gcloud storage rm $BUCKET_NAME --recursive

# 3. Delete the table
bq rm --table=true --force=true $BIGQUERY_DATASET_ID.$TABLE_NAME

# 4. Delete the dataset
bq rm --dataset=true --force=true $BIGQUERY_DATASET_ID

# 5. Delete the Pub/Sub topic
gcloud pubsub topics delete $PUBSUB_TOPIC

# 6. Delete the scheduler
gcloud scheduler jobs delete $SCHEDULER --location=$REGION

# 7. Delete de function on Google Functions
gcloud functions delete import_mysql_to_bigquery --region=$REGION

# 8. Deactivate the API's
gcloud services disable bigquery.googleapis.com --force
gcloud services disable cloudsql.googleapis.com --force
gcloud services disable appengine.googleapis.com --force
