#!/bin/bash

sudo apt-get update && apt-get upgrade

aws s3 cp --region eu-west-1 s3:///ecsd-mdanidl/go-demo/artifacts/${version}/go-demo .
sudo chmod +x ./go-demo
sudo mv ./go-demo /usr/local/bin/go-demo

go-demo >> /var/log/go-demo.log 2>&1 &
