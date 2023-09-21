#!/bin/bash

source constants.sh

### Enable the Dataproc API
gcloud services enable dataproc.googleapis.com

# ### Cloud Storage
# # Create a bucket
# gcloud storage buckets create $BUCKET --location=$REGION

# # Upload files from local filesystem
# gcloud storage cp ./book.txt $BUCKET/input/
# gcloud storage cp ./word_count.py $BUCKET/input/
# gcloud storage ls $BUCKET/input/

# ### Start Dataproc cluster
# gcloud dataproc clusters create $CLUSTER \
# --region=$REGION \
# --zone=$ZONE \
# --num-masters=1 \
# --master-machine-type=n2-standard-2 \
# --service-account=$SERVICE_ACCOUNT

# gcloud dataproc jobs submit pyspark $BUCKET/input/word_count.py \
# --cluster=$CLUSTER \
# --region=$REGION \
# -- $BUCKET/input/book.txt $BUCKET/output/

# job_id=$(gcloud dataproc jobs list --region=$REGION | grep DONE | awk '{print $1}')

### List result
gcloud storage ls $BUCKET/output/

### Copy result to local machine and merge files
gcloud storage cp $BUCKET/output/* .
cat part-00000 part-00001 > result.txt

## CLEANUP
gcloud dataproc jobs delete $job_id --region=$REGION
gcloud dataproc clusters delete $CLUSTER --region=$REGION
gcloud storage rm -r $BUCKET

gcloud services disable dataproc.googleapis.com
