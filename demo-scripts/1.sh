#!/bin/bash

cat << EOS
cd backend && go build -v -o devops_handson && ./devops_handson
EOS

cd backend && go build -v -o devops_handson && ./devops_handson
