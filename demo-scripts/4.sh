#!/bin/bash

PROJECT_ID=$(gcloud config get-value project 2> /dev/null)

cat << EOS
sed -e "s/FIXME/${PROJECT_ID}/" gke-config/deployment.yaml | kubectl apply -f -
kubectl apply -f gke-config/loadbalancer.yaml
EOS

sed -e "s/FIXME/${PROJECT_ID}/" gke-config/deployment.yaml | kubectl apply -f -
kubectl apply -f gke-config/loadbalancer.yaml
