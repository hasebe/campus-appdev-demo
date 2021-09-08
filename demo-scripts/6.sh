#!/bin/bash

PROJECT_ID=$(gcloud config get-value project 2> /dev/null)

cat << EOS
gcloud source repos create devops-handson
git remote add google https://source.developers.google.com/p/${PROJECT_ID}/r/devops-handson
git push google main
EOS

gcloud source repos create devops-handson
git remote add google https://source.developers.google.com/p/${PROJECT_ID}/r/devops-handson
git push google main
