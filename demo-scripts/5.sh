#!/bin/bash

PROJECT_ID=$(gcloud config get-value project 2> /dev/null)

cat << EOS
gcloud run deploy devops-handson --image asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1 --service-account devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com --region asia-northeast1 --allow-unauthenticated
EOS

gcloud run deploy devops-handson --image asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1 --service-account devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com --region asia-northeast1 --allow-unauthenticated

export CB_SA=$(gcloud projects get-iam-policy ${PROJECT_ID} | grep cloudbuild.gserviceaccount.com | uniq | cut -d ':' -f 2)
gcloud run services add-iam-policy-binding devops-handson \
  --member="serviceAccount:$CB_SA" \
  --role="roles/run.admin" \
  --region="asia-northeast1"

