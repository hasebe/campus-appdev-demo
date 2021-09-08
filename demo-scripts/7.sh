#!/bin/bash

cat << EOS
gcloud beta builds triggers create cloud-source-repositories --description="devopshandson" --repo=devops-handson --branch-pattern=".*" --build-config="cloudbuild.yaml"
EOS

gcloud beta builds triggers create cloud-source-repositories --description="devopshandson" --repo=devops-handson --branch-pattern=".*" --build-config="cloudbuild.yaml"
