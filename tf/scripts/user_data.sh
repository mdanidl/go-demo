#!/bin/bash

sudo apt-get update && apt-get upgrade
sudo apt-get install awscli -y
export APP_ENV=${env}
export VERSION_COLOUR=${v_col}
sudo echo 'APP_ENV=${env}' >> /etc/environment
sudo echo 'VERSION_COLOUR=${v_col}' >> /etc/environment

aws s3 cp --region eu-west-1 s3:///ecsd-mdanidl/go-demo/artifacts/${v_num}/go-demo .
sudo chmod +x ./go-demo
sudo mv ./go-demo /usr/local/bin/go-demo

go-demo >> /var/log/go-demo.log 2>&1 &
