#!/bin/bash

PROJECT_ID=$(gcloud config get-value project 2> /dev/null)

cat << EOS
docker build -t asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1 .
docker run -d -p 8080:8080 --name devops-handson asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1
EOS

docker build -t asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1 .
docker run -d -p 8080:8080 --name devops-handson asia-northeast1-docker.pkg.dev/${PROJECT_ID}/gcp-getting-started-devops/handson:v1
