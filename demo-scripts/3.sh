#!/bin/bash

PROJECT_ID=$(gcloud config get-value project 2> /dev/null)

cat << EOS
docker push asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1
EOS

docker push asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1
