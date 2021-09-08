#!/bin/bash
set -e

PROJECT_ID=$(gcloud config get-value project 2> /dev/null)

if [ -z "${PROJECT_ID}" ]; then
	echo 'Set project_id with gcloud config set project ...'
	exit 1
fi

echo "### Enable services..."
gcloud services enable \
  cloudbuild.googleapis.com \
  sourcerepo.googleapis.com \
  cloudresourcemanager.googleapis.com \
  container.googleapis.com \
  stackdriver.googleapis.com \
  cloudtrace.googleapis.com \
  cloudprofiler.googleapis.com \
  logging.googleapis.com \
  iamcredentials.googleapis.com \
  artifactregistry.googleapis.com \
  run.googleapis.com

echo "### Set default region/zone to Tokyo..."
gcloud config set compute/region asia-northeast1
gcloud config set compute/zone asia-northeast1-c

echo "### Create a default service account (devops-handson-gsa)..."
gcloud iam service-accounts create devops-handson-gsa --display-name "DevOps HandsOn Service Account"

echo "### Assign roles to the service account..."
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com --role roles/cloudprofiler.agent
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com --role roles/cloudtrace.agent
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com --role roles/monitoring.metricWriter
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com --role roles/stackdriver.resourceMetadata.writer
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com --role roles/clouddebugger.agent

echo "### Create a GKE cluster(k8s-devops-handson)..."
gcloud container clusters create "k8s-devops-handson" \
  --enable-stackdriver-kubernetes \
  --enable-ip-alias \
  --release-channel stable \
  --workload-pool ${PROJECT_ID}.svc.id.goog


echo "### Get the credential for the cluster..."
gcloud container clusters get-credentials k8s-devops-handson

echo "### Create a namespace for the handson..."
kubectl create namespace devops-handson-ns

echo "### Configure workload identity..."
kubectl create serviceaccount --namespace devops-handson-ns devops-handson-ksa
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:${PROJECT_ID}.svc.id.goog[devops-handson-ns/devops-handson-ksa]" \
  devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com
kubectl annotate serviceaccount \
  --namespace devops-handson-ns \
  devops-handson-ksa \
  iam.gke.io/gcp-service-account=devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com

echo "### Configure docker..."
gcloud auth configure-docker asia-northeast1-docker.pkg.dev


echo "### Assign appropriate roles to Cloud Build service account"
export CB_SA=$(gcloud projects get-iam-policy ${PROJECT_ID} | grep cloudbuild.gserviceaccount.com | uniq | cut -d ':' -f 2)
gcloud projects add-iam-policy-binding ${PROJECT_ID} --member serviceAccount:$CB_SA --role roles/container.admin
gcloud iam service-accounts add-iam-policy-binding \
  devops-handson-gsa@${PROJECT_ID}.iam.gserviceaccount.com \
  --member="serviceAccount:$CB_SA" \
  --role="roles/iam.serviceAccountUser"

echo "### Configure git client..."
git config --global credential.https://source.developers.google.com.helper gcloud.sh
git config --global user.name "USERNAME"
git config --global user.email "USERNAME@EXAMPLE.com"

echo "### Create an artifact repository..."
gcloud artifacts repositories create gcp-getting-started-devops \
  --repository-format=docker \
  --location=asia-northeast1 \
  --description="Docker repository for DevOps Handson"

echo "### Update PATH for demo scripts..."
echo 'export PATH=${PWD}/demo-scripts:$PATH'
