#!/bin/bash

PROJECT_ID="my-projekt"
REGION="us-west..."
SERVICE_ACCOUNT=service-account@my-project.iam.gserviceaccount.com
PUBSUB_TOPIC=
SCHEDULER=

# Cloud Storage
BUCKET_NAME=gs://...
SOURCE=Folder on local machine
FILENAME=queries.sql
QUERIES=$SOURCE/$FILENAME

# MySQL
INSTANCE_NAME="my-instance"
DATABASE_VERSION="MYSQL_5_7"
CPU=1
MEMORY=4GB
ROOT_PASSWORD="..."
DATABASE_NAME=
MYSQL_TABLE_NAME=

# BigQuery
BIGQUERY_DATASET_ID=
BIGQUERY_TABLE_NAME=
BIGQUERY_DATA_FILE=data.csv
