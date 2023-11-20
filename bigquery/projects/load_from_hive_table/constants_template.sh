#!/bin/bash

FILENAME=purchase_history.csv
PROJECT_ID=my-project
REGION=europe-west1
SERVICE_ACCOUNT=...@my-project.iam.gserviceaccount.com
SOURCE=/localmachine
ZONE=europe-west1-a

# Cloud Storage
BUCKET_NAME_CLEAN=...bucket-name
BUCKET_NAME=gs://$BUCKET_NAME_CLEAN

# Dataproc
CLUSTER_NAME=create-hive-table

# BigQuery
DATASET_ID=ecommerce
TABLE_NAME=purchases
