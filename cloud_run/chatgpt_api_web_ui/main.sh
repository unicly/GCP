#!/bin/bash

source constants.sh

# Enable Cloud Run API
gcloud services enable run.googleapis.com

# OPTION 1 - Create and deploy the container image on Google Container Registry
# and run it on Cloud Run

# Built the container image
gcloud builds submit --tag gcr.io/$PROJECT_ID/$IMAGE_NAME

# Deploy the container image to Cloud Run
# The --allow-unauthenticated flag is optional and it makes your app publicly accessible.
# The environment OPENAI_API_KEY variable is set during the run instead of hardcoding it in the Dockerfile
gcloud run deploy $SERVICE_NAME \
--image gcr.io/$PROJECT_ID/$IMAGE_NAME \
--platform managed \
--region $REGION \
--allow-unauthenticated \
--set-env-vars OPENAI_API_KEY=$OPENAI_KEY \
--port 3000


# # OPTION 2 - Build the container image locally and then deploy it to GCP

# # Build the Docker image locally
# docker build -t $IMAGE_NAME .

# # Tag the local image
# docker tag $IMAGE_NAME gcr.io/$PROJECT_ID/$IMAGE_NAME

# # Push the Docker image to Google Container Registry
# # To push a locally built image to GCR, you'd first need to configure Docker 
# # to use the gcloud command-line tool to authenticate requests to GCR:
# gcloud auth configure-docker

# # Push the image to Google Container Registry
# docker push gcr.io/[PROJECT-ID]/$IMAGE_NAME
